//
//  CSVParsingService.swift
//  Graph
//
//  Created by Dmitriy Mkrtumyan on 17.02.24.
//

import UIKit

final class CSVParsingService: ObservableObject {
    
    static let shared = CSVParsingService()
    
    private init() { }
    
    func parse(with url: URL) async throws -> CSVData {
        do {
            let csvString = try String(contentsOf: url)
            let rows = csvString.components(separatedBy: "\n")
                .filter { !$0.isEmpty }
                .map { $0.components(separatedBy: ";") }

            return rows
        } catch ParseCSVError.failCSVtoStringParse {
            print(ParseCSVError.failCSVtoStringParse.rawValue)
        }
        
        return CSVData.init()
    }
}
