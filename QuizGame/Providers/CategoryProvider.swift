//  CategoryProvider.swift
//  Created by Dominik Hel on 30.10.2021.

//  MARK: - Imports
import Foundation

//  MARK: - Class CategoryProvider
final class CategoryProvider {
    //  MARK: - Constants and variables
    /// Shared property of the CategoryProvider class (singleton).
    static let shared = CategoryProvider()
    
    //  MARK: - Inits
    /// Private initializer.
    private init() {}
    
    //  MARK: - Functions
    /// Retrieves category data from the URL and creates an array instance of the Category struct from it.
    ///
    /// - Parameters:
    ///     - completion: Escaping closure.
    func fetchCategoris(completion: @escaping (Result<[Category], Error>) -> (Void)) {
        guard let finalURL = URL(string: "https://opentdb.com/api_category.php") else {
            completion(.failure(CustomError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: finalURL) { data, _, error in
            guard let jsondata = data, error == nil else {
                completion(.failure(CustomError.URLSessionError))
                return
            }
            
            var data: Categoris?
            do  {
                data = try JSONDecoder().decode(Categoris.self, from: jsondata)
            }
            catch {
                completion(.failure(CustomError.JSONDecoderError))
                return
            }
            
            guard let final = data else {
                completion(.failure(CustomError.emptyData))
                return
            }
            completion(.success(final.trivia_categories))
        }
        task.resume()
    }
}
