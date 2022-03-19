//  Category.swift
//  Created by Dominik Hel on 30.10.2021.

//  MARK: - Imports
import Foundation

//  MARK: - Struct Category
struct Category: Codable {
    let id: Int
    var name: String
    
    //  MARK: - Functions
    mutating func editName() {
        name = name.replacingOccurrences(of: "Entertainment: ", with: "")
        name = name.replacingOccurrences(of: "Science: ", with: "")
    }
}

//  MARK: - Struct Categoris
struct Categoris: Codable {
    let trivia_categories: [Category]
}
