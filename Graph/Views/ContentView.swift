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
    @State private var isDatePickerViewOpened: Bool = false
    @State var isCSVPickerPresented: Bool = false
    @State private var areButtonsAtCentre = false
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack(alignment: .center) {
                ScrollView([.horizontal, .vertical]) {
                    
                    ChartView(viewModel: viewModel,
                              geometry: geometry)
                }
                .gesture(TapGesture().onEnded({ _ in
                    viewModel.currentScale = 1.0
                }))
                
                Spacer()
                
                HStack(alignment: .center, spacing: 50) {
                    
                    SelectIntervalButton(viewModel: viewModel,
                                         isDatePickerViewOpened: $isDatePickerViewOpened)
                    
                    ImportCSVButton(viewModel: viewModel,
                                    isCSVPickerPresented: $isCSVPickerPresented,
                                    areButtonsAtCentre: $areButtonsAtCentre)
                }
                .frame(height: geometry.size.height)
                .padding()
                .onAppear {
                    withAnimation {
                        areButtonsAtCentre = true
                    }
                }
                .offset(y: areButtonsAtCentre ? 0 : (geometry.size.height) / 2.2 )
            }
        }
    }
}

#Preview {
    ContentView()
}
