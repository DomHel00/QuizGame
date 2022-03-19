//  Quiz.swift
//  Created by Dominik Hel on 30.10.2021.

//  MARK: - Imports
import Foundation

//  MARK: - Struct Questions
struct Questions: Codable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    
    //  MARK: - Functions
    func getAllAnswers() -> [String]{
        var answers = [String]()
        answers.append(correct_answer)
        answers.append(contentsOf: incorrect_answers)
        return answers
    }
}

//  MARK: - Struct Quiz
struct Quiz: Codable {
    let response_code: Int
    let results: [Questions]
}
