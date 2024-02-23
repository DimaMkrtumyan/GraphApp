//
//  ContentView.swift
//  Graph
//
//  Created by Dmitriy Mkrtumyan on 17.02.24.
//

import SwiftUI
import Charts

struct MainView: View {
     
    @StateObject private var viewModel = CSVViewModel(csvParsingService: CSVParsingService.shared)
    @State private var isDatePickerViewOpened: Bool = false
    @State var isCSVPickerPresented: Bool = false
    @State private var areButtonsAtCentre = false
    
    var body: some View {
        
        GeometryReader { geometry1 in
            VStack {
                Spacer()
                VStack {
                    GeometryReader { geometry2 in
                        ScrollView([.horizontal, .vertical]) {
                            
                            ChartView(viewModel: viewModel,
                                      geometry: geometry2)
                        }
                        .padding()
                        .frame(width: geometry2.size.width,
                               height: geometry2.size.height)
                        .gesture(TapGesture().onEnded({ _ in
                            viewModel.currentScale = 1.0
                        }))
                    }
                }
                .frame(width: geometry1.size.width,
                       height: geometry1.size.height / 1.1)
                
                Spacer()
                                
                HStack() {
                    Spacer()
                        .frame(width: 20)
                    SelectIntervalButton(viewModel: viewModel,
                                         isDatePickerViewOpened: $isDatePickerViewOpened)
                    Spacer()
                    ImportCSVButton(viewModel: viewModel,
                                    isCSVPickerPresented: $isCSVPickerPresented,
                                    areButtonsAtCentre: $areButtonsAtCentre)
                    Spacer()
                        .frame(width: 30)
                }
                .frame(width: geometry1.size.width - 30,
                       height: 40)
                .onAppear {
                    withAnimation {
                        areButtonsAtCentre = true
                    }
                }
                .offset(y: areButtonsAtCentre ? -(geometry1.size.height) / 2.3 : -2)
            }
        }
    }
}

#Preview {
    MainView()
}
