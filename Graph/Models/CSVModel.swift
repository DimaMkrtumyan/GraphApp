//
//  CSVModel.swift
//  Graph
//
//  Created by Dmitriy Mkrtumyan on 17.02.24.
//

import Foundation
import SwiftUI

typealias CSVData = [[String]]

struct CSVModel: Identifiable {
    var id = UUID()
    var date: Date
    var value: Int
    var color: Color
    
    init(date: Date, value: Int) {
        self.date = date
        self.value = value
        self.color = Color(red: .random(in: 0...1),
                           green: .random(in: 0...1),
                           blue: .random(in: 0...1))
    }
}
