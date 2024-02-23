//
//  ContentView.swift
//  Graph
//
//  Created by Dmitriy Mkrtumyan on 17.02.24.
//

import SwiftUI
import Charts

struct ContentView: View {
    
    @StateObject private var viewModel = CSVViewModel(csvParsingService: CSVParsingService())
    @State private var currentScale = 1.0
    @State private var lastScale = 1.0
    @State private var isDatePickerViewOpened: Bool = false
    private let minScale = 0.8
    private let maxScale = 2.0
    
    var body: some View {
        
        let flagData = viewModel.csvData.isEmpty ? [CSVModel]() : viewModel.csvData
        
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical]) {
                VStack {
                    Chart {
                        
                        let currentCSVModel = $viewModel.filteredCSVData.isEmpty ? viewModel.csvData : viewModel.filteredCSVData
                        
                        ForEach(currentCSVModel) { row in
                            
                            BarMark(x: .value("Value", row.date, unit: .second),
                                    y: .value("Type", row.value))
                            .foregroundStyle(row.color)
                        }
//                        if viewModel.filteredCSVData.isEmpty {
//                            
//                            ForEach(viewModel.csvData) { row in
//                                
//                                BarMark(x: .value("Value", row.date, unit: .second),
//                                        y: .value("Type", row.value))
//                                .foregroundStyle(row.color)
//                            }
//                        } else {
//                            
//                            ForEach(viewModel.filteredCSVData) { row in
//                                
//                                BarMark(x: .value("Value", row.date, unit: .second),
//                                        y: .value("Type", row.value))
//                                .foregroundStyle(row.color)
//                            }
//                        }
                        
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
                    .frame(width: CGFloat(calculateChartHeight(flagData)),
                           height: geometry.size.height)
                }
                .scaleEffect(currentScale)
                .gesture(
                    MagnificationGesture()
                        .onChanged { newScale in
                            adjustScale(from: newScale)
                            
                        }
                        .onEnded{ _ in
                            validateScale()
                            self.lastScale = 1.0
                        }
                )
            }
            .gesture(TapGesture().onEnded({ _ in
                self.currentScale = 1.0
            }))
        }
        
        Spacer()
        
        HStack(alignment: .center, spacing: 50) {
            Button(action: {
                isDatePickerViewOpened.toggle()
            }, label: {
                Text("Select Interval")
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.gray)
                            .frame(width: 150, height: 40)
                    )
            })
            .padding()
            .sheet(isPresented: $isDatePickerViewOpened) {
                DateAndIntervalPickerView(isPickerViewOpened: $isDatePickerViewOpened) { intervalModel in
                    let filteredData = self.viewModel.filterCSVModel(intervalModel)
                    self.viewModel.filteredCSVData = filteredData
                }
            }
            
            Button(action: {
                viewModel.isCSVPickerPresented = true
            }, label: {
                Text("Import CSV File")
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.blue)
                            .frame(width: 150, height: 40)
                    )
            })
            .sheet(isPresented: $viewModel.isCSVPickerPresented) {
                viewModel.importCSV()
            }
        }
        .padding()
    }
    
    func adjustScale(from newScale: MagnificationGesture.Value) {
        let delta = newScale / lastScale
        currentScale *= delta
        lastScale = newScale
    }
    
    func getMinimumScale() -> CGFloat {
        return max(currentScale, minScale)
    }
    
    func getMaximumScale() -> CGFloat {
        return min(currentScale, maxScale)
    }
    
    func validateScale() {
        currentScale = getMinimumScale()
        currentScale = getMaximumScale()
    }
    
    func calculateChartHeight(_ data: [CSVModel]) -> CGFloat {
        guard !data.isEmpty else { return CGFloat(0) }
        let itemHeight: CGFloat = 20
        let spacing: CGFloat = 5
        return CGFloat(data.count) * itemHeight + CGFloat(data.count - 1) * spacing
    }
}

#Preview {
    ContentView()
}
