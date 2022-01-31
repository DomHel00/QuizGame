//  CategoryProvider.swift
//  Created by Dominik Hel on 30.10.2021.

//  MARK: - Imports
import Foundation

//  MARK: - Class CategoryProvider
final class CategoryProvider {
    //  MARK: - Constants and variables
    static let shared = CategoryProvider()
    private let categoryURL = URL(string: "https://opentdb.com/api_category.php")
    
    //  MARK: - Inits
    private init() {}
    
    //  MARK: - Functions
    func fetchCategoris(completion: @escaping (Result<[Category], Error>) -> (Void)) {
        guard let finalURL = categoryURL else {
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
