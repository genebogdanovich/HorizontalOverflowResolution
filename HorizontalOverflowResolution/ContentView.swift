//
//  ContentView.swift
//  HorizontalOverflowResolution
//
//  Created by Gene Bogdanovich on 13.11.24.
//

import SwiftUI
import Charts

// MARK: - StepCount

struct StepCount: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
}

// MARK: - ContentView

struct ContentView: View {
    @State private var stepCountRecords = [StepCount]()
    @State private var selectedDate: Date?
    
    @State private var fitToChart: Bool = false
    
    var body: some View {
        VStack {
            Chart(stepCountRecords) { record in
                BarMark(
                    x: .value("Date", record.date, unit: .day),
                    y: .value("Count", record.steps)
                )
                
                if let selectedDate {
                    RuleMark(x: .value("Selected", selectedDate, unit: .day))
                        .foregroundStyle(Color(.secondarySystemFill).opacity(0.3))
                        .annotation(
                            position: .top,
                            overflowResolution: AnnotationOverflowResolution(x: horizontalAnnotationOverflowResolutionStrategy, y: .disabled)
                        ) {
                            Text(selectedDate.formatted())
                                .padding()
                                .background(Color(.secondarySystemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                }
            }
            .chartXSelection(value: $selectedDate)
            .aspectRatio(1, contentMode: .fit)
            
            Toggle(isOn: $fitToChart) {
                Text("Fit to chart")
            }
        }
        .padding()
        .onAppear {
            generateRecords()
        }
    }
    
    private var horizontalAnnotationOverflowResolutionStrategy: AnnotationOverflowResolution.Strategy {
        if fitToChart {
            return .fit(to: .chart)
        } else {
            return .automatic
        }
    }
    
    private func generateRecords() {
        self.stepCountRecords = (0...15).map { index in
            let date = Calendar.current.date(byAdding: .day, value: -index, to: .now)!
            let record = StepCount(date: date, steps: Int.random(in: 500...999))
            return record
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
