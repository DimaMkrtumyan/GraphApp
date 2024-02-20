//
//  ContentView.swift
//  Graph
//
//  Created by Dmitriy Mkrtumyan on 17.02.24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = CSVViewModel(csvParsingService: CSVParsingService())
    
    var body: some View {
        VStack {
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
                viewModel.importCSV { data in
                    print(data)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
