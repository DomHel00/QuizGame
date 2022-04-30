//  UserDefaultsStorage.swift
//  Created by Dominik Hel on 13.01.2022.

//  MARK: - Imports
import Foundation

//  MARK: - Class UserDefaultsStorage
final class UserDefaultsStorage {
    //  MARK: - Constants and variables
    /// Shared property of the UserDefaultsStorage class (singleton).
    static let shared = UserDefaultsStorage()
    /// Property of the UserDefaults.standard.
    private let userDefaults = UserDefaults.standard
    
    //  MARK: - Inits
    /// Private initializer.
    private init() {}

    //  MARK: - Functions
    /// Save variables to the storage.
    ///
    /// - Parameters:
    ///     - numberOfQuestions: The number of questions.
    ///     - difficultyType: The type of the difficulty.
    func save(numberOfQuestions: Int, difficultyType: String) {
        userDefaults.set(numberOfQuestions, forKey: "numberOfQuestions")
        userDefaults.set(difficultyType, forKey: "difficultyType")
    }
    
    /// Returns saved property of number of questions or default value.
    func loadNumberOfQuestions() -> Int{
        let numberOfQuestions = userDefaults.object(forKey: "numberOfQuestions") as? Int ?? 10
        return numberOfQuestions
    }
    
    /// Returns saved property of type of difficulty or default value.
    func loadDifficultyType() -> String{
        let difficultyType = userDefaults.object(forKey: "difficultyType") as? String ?? "All"
        return difficultyType
    }
}
