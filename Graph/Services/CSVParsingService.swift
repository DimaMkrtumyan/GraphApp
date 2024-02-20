//
//  CSVParsingService.swift
//  Graph
//
//  Created by Dmitriy Mkrtumyan on 17.02.24.
//

import UIKit

final class CSVParsingService: ObservableObject {
    
    func parse(by url: URL, with completion: @escaping (CSVData) -> Void) {
        
        Task.detached { [ weak self ] in
            
            guard let self else { return }
            
            do {
                let data = try await self.injectComponents(fromURL: url)
                completion(data)
            } catch {
                print("Error parsing CSV: \(error.localizedDescription)")
            }
        }
    }
    
    func injectComponents(fromURL: URL) async throws -> [[String]] {
        let csvString = try String(contentsOf: fromURL)
        let rows = csvString.components(separatedBy: "\n")
            .filter { !$0.isEmpty }
            .map { $0.components(separatedBy: ",") }
        return rows
    }
}

