//  CustomError.swift
//  Created by Dominik Hel on 06.11.2021.

//  MARK: - Imports
import Foundation

//  MARK: - CustomError
/// Custom errors for fetch functions.
enum CustomError: Error {
    /// A style for invalid url.
    case invalidURL
    /// A style for URLSession error.
    case URLSessionError
    /// A style for JSONDecoder error.
    case JSONDecoderError
    /// A style for empty data error.
    case emptyData
}
