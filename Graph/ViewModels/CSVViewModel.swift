//
//  CSVViewModel.swift
//  Graph
//
//  Created by Dmitriy Mkrtumyan on 17.02.24.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

final class CSVViewModel: ObservableObject {
    
    @Published var isPickerPresented: Bool = false
    private var csvParsingService: CSVParsingService

    init(csvParsingService: CSVParsingService) {
        self.csvParsingService = csvParsingService
    }
    
    func importCSV(_ completion: @escaping (CSVData) -> Void) -> DocumentPickerView {
                
        let documentPicker = DocumentPickerView() { [weak self] url in
            
            guard let self else { return }
            
            self.csvParsingService.parse(by: url) { data in
                completion(data)
            }
            
            self.isPickerPresented = false
        }
        //    onDocumentPickerCancelled: {
        //#warning("Handle document cancelation")
        //    }
        
        return documentPicker
    }
}
