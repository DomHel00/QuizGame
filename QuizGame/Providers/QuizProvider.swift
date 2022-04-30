//  QuizProvider.swift
//  Created by Dominik Hel on 30.10.2021.

//  MARK: - Imports
import Foundation

//  MARK: - Class QuizProvider
final class QuizProvider {
    //  MARK: - Constants and variables
    /// Shared property of the QuizProvider class (singleton).
    static let shared = QuizProvider()
    
    //  MARK: - Inits
    /// Private initializer.
    private init() {}
    
    //  MARK: - Functions
    /// Retrieves quiz data from the URL and creates an array instance of the Question struct from it.
    ///
    /// - Parameters:
    ///     - categoryID: The category ID.
    ///     - numberOfQuestions: The number of questions.
    ///     - difficultyType: The type of the difficulty.
    ///     - completion: Escaping closure.
    func fetchQuiz(categoryID: Int, numberOfQuestions: Int, difficultyType: String, completion: @escaping (Result<[Question], Error>) -> (Void)) {
        let urlString: String
        if difficultyType.lowercased() == "all" {
            urlString = "https://opentdb.com/api.php?amount=\(numberOfQuestions)&category=\(categoryID)"
        } else {
            urlString = "https://opentdb.com/api.php?amount=\(numberOfQuestions)&category=\(categoryID)&difficulty=\(difficultyType.lowercased())"
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
