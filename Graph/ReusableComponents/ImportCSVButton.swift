//
//  ImportCSVButton.swift
//  Graph
//
//  Created by Dmitriy Mkrtumyan on 23.02.24.
//

import SwiftUI

struct ImportCSVButton: View {
    
    var viewModel: CSVViewModel
    @Binding var isCSVPickerPresented: Bool
    @Binding var areButtonsAtCentre: Bool
    
    var body: some View {
        
        Button(action: {
            isCSVPickerPresented = true
            areButtonsAtCentre = false
        }, label: {
            Text("Import CSV File")
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.blue)
                        .frame(width: 150, height: 40)
                )
        })
        .popover(isPresented: $isCSVPickerPresented) {
            
            viewModel.importCSV(pickerOpenedStatus: { isPickerOpened in
                if isPickerOpened {
                    areButtonsAtCentre = true
                    isCSVPickerPresented = isPickerOpened
                } else {
                    areButtonsAtCentre = false
                    isCSVPickerPresented = isPickerOpened
                }
            })
                .background(.white)
                .presentationDragIndicator(.visible)
                .presentationCompactAdaptation(.fullScreenCover)
        }
    }
}
