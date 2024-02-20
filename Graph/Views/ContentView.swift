//
//  ContentView.swift
//  Graph
//
//  Created by Dmitriy Mkrtumyan on 17.02.24.
//

import SwiftUI
import Charts

struct ContentView: View {
    
    //    @State private var finalScale: CGFloat = 1.0
    //    var mockData: [CSVModel2] = [
    //        .init(date: "07:44:13", value: 100),
    //        .init(date: "08:44:20", value: 105),
    //        .init(date: "09:44:30", value: 110),
    //        .init(date: "10:44:40", value: 110),
    //        .init(date: "11:44:50", value: 115),
    //        .init(date: "12:44:59", value: 120),
    //        .init(date: "13:45:00", value: 125),
    //        .init(date: "14:45:10", value: 130),
    //        .init(date: "15:45:15", value: 135),
    //        .init(date: "16:45:20", value: 140),
    //        .init(date: "17:45:30", value: 200)
    //    ]
    
    @StateObject private var viewModel = CSVViewModel(csvParsingService: CSVParsingService())
    @State private var currentScale = 1.0
    @State private var lastScale = 1.0
    private let minScale = 0.6
    private let maxScale = 5.0
    
    var body: some View {
        
        let flagData = viewModel.csvData.isEmpty ? [CSVModel]() : viewModel.csvData
        
        VStack {
            GeometryReader { geometry in
                ScrollView([.horizontal, .vertical]) {
                    VStack {
                        Chart {
                            ForEach(/*mockData*/ viewModel.csvData) { row in
                                BarMark(x: .value("Value", row.date),
                                        y: .value("Type", row.value /*, unit: .second*/))
                                .foregroundStyle(row.color)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .frame(width: CGFloat(/*mockData.count) * 30*/ calculateChartHeight(flagData)),
                               height: geometry.size.height)
                    }
                    .scaleEffect(currentScale/* + finalScale*/)
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
            
            Button(action: {
                viewModel.isPickerPresented = true
            }, label: {
                Text("Import CSV File")
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.blue)
                            .frame(width: 180, height: 40)
                    )
            })
            .sheet(isPresented: $viewModel.isPickerPresented) {
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
