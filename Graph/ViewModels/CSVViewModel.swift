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
    @Published var csvData: [CSVModel] = []
    private var csvParsingService: CSVParsingService
    
    init(csvParsingService: CSVParsingService) {
        self.csvParsingService = csvParsingService
    }
    
    func importCSV() -> DocumentPickerView {
        
        let documentPicker = DocumentPickerView() { [weak self] url in
            
            guard let self else { return }
                        
            Task.detached {
                do {
                    let data = try await self.csvParsingService.parse(with: url)
                    DispatchQueue.main.async {
                        for i in 0..<data.count {
                            if let date = data[i].first, let value = data[i].last {
                                if let wrappedValue = Int(value) {
                                    let convertedDate = self.convertDateStringToDate(dateString: date)
                                    self.csvData.append(.init(date: convertedDate, value: wrappedValue))
                                }
                            }
                        }
                        print("CSV Data:", self.csvData)
                        self.isPickerPresented = false
                    }
                } catch {
                    print("Error parsing CSV:", error)
                }
            }
        }
        //    onDocumentPickerCancelled: {
        //#warning("Handle document cancelation")
        //    }
        
        return documentPicker
    }
    
    public func convertDateStringToDate(dateString: String) -> Date {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            print("Invalid date string")
            return Date()
        }
    }
}
