//
//  CSVModel.swift
//  Graph
//
//  Created by Dmitriy Mkrtumyan on 17.02.24.
//

import Foundation

typealias CSVData = [[String]]

struct CSVModel: Identifiable {
    var id = UUID()
    var data: Data
    var value: Int
}
