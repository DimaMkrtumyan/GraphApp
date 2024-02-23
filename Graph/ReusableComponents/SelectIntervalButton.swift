//
//  SelectIntervalButton.swift
//  Graph
//
//  Created by Dmitriy Mkrtumyan on 23.02.24.
//

import SwiftUI

struct SelectIntervalButton: View {
    
    var viewModel: CSVViewModel
    @Binding var isDatePickerViewOpened: Bool
    
    var body: some View {
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
                let filteredData = viewModel.filterCSVModel(intervalModel)
                viewModel.filteredCSVData = filteredData
            }
        }
    }
}
