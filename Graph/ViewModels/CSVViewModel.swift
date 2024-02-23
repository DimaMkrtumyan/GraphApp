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
    
    @Published var isCSVPickerPresented: Bool = false
    @Published var csvData: [CSVModel] = []
    @Published var filteredCSVData: [CSVModel] = []

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
                        self.isCSVPickerPresented = false
                    }
                } catch {
                    print("Error parsing CSV:", error)
                }
            }
        }
        
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
    
    private func combineDate(_ date: Date, withTime time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        combinedComponents.second = timeComponents.second
        
        print(combinedComponents.year)
        print(combinedComponents.month)
        print(combinedComponents.day)
        print(combinedComponents.hour)
        print(combinedComponents.minute)
        print(combinedComponents.second)
        
        return calendar.date(from: combinedComponents)!
    }
    
    func filterCSVModel(_ intervalModel: TimeIntervalModel) -> [CSVModel] {
        
        let startDate = combineDate(intervalModel.day, withTime: intervalModel.startTime)
        let endDate = combineDate(intervalModel.day, withTime: intervalModel.endTime)
        let filteredCSVModel = self.csvData.filter { model in
            return startDate <= model.date && model.date <= endDate
        }
        print(filteredCSVModel)
        return filteredCSVModel
    }
}
