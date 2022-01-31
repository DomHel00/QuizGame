//  QuizProvider.swift
//  Created by Dominik Hel on 30.10.2021.

//  MARK: - Imports
import Foundation

//  MARK: - Class QuizProvider
final class QuizProvider {
    //  MARK: - Constants and variables
    static let shared = QuizProvider()
    
    //  MARK: - Inits
    private init() {}
    
    //  MARK: - Functions
    func fetchQuiz(urlID: Int, numberOfQuestions: Int, typesOfDifficulty: String, completion: @escaping (Result<[Questions], Error>) -> (Void)) {
        let urlString: String
        if typesOfDifficulty.lowercased() == "all" {
            urlString = "https://opentdb.com/api.php?amount=\(numberOfQuestions)&category=\(urlID)"
        } else {
            urlString = "https://opentdb.com/api.php?amount=\(numberOfQuestions)&category=\(urlID)&difficulty=\(typesOfDifficulty.lowercased())"
        }
        
        guard let finalURL = URL(string: urlString) else {
            completion(.failure(CustomError.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: finalURL) { data, _, error in
            guard let jsondata = data, error == nil else {
                completion(.failure(CustomError.URLSessionError))
                return
            }
            
            var data: Quiz?
            do  {
                data = try JSONDecoder().decode(Quiz.self, from: jsondata)
            }
            catch {
                completion(.failure(CustomError.JSONDecoderError))
                return
            }
            
            guard let final = data else {
                completion(.failure(CustomError.emptyData))
                return
            }
            completion(.success(final.results))
        }
        task.resume()
    }
}
