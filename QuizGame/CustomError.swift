//  CustomError.swift
//  Created by Dominik Hel on 06.11.2021.

//  MARK: - Imports
import Foundation

//  MARK: - CustomError
enum CustomError: Error {
    case invalidURL
    case URLSessionError
    case JSONDecoderError
    case emptyData
}
