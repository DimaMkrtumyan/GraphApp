//
//  ChartView.swift
//  Graph
//
//  Created by Dmitriy Mkrtumyan on 23.02.24.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    var viewModel: CSVViewModel
    var geometry: GeometryProxy

    var body: some View {
        let flagData = viewModel.csvData.isEmpty ? [CSVModel]() : viewModel.csvData
        let currentCSVModel = viewModel.filteredCSVData.isEmpty ? viewModel.csvData : viewModel.filteredCSVData

        VStack {
            Chart {
                
                ForEach(currentCSVModel) { row in
                    
                    BarMark(x: .value("Value", row.date, unit: .second),
                            y: .value("Type", row.value))
                    .foregroundStyle(row.color)
                }
            }
            .padding()
            .chartXAxis {
                AxisMarks(values: viewModel.csvData.map{ $0.date }) { date in
                    AxisTick()
                    AxisValueLabel(format: .dateTime.second(.defaultDigits))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(width: CGFloat(viewModel.calculateChartHeight(flagData)),
                   height: geometry.size.height - 17)
        }
        .scaleEffect(viewModel.currentScale)
        .gesture(
            MagnificationGesture()
                .onChanged { newScale in
                    viewModel.adjustScale(from: newScale)
                }
                .onEnded{ _ in
                    viewModel.validateScale()
                    viewModel.lastScale = 1.0
                }
        )
    }
}
