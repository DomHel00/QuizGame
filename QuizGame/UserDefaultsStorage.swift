//  UserDefaultsStorage.swift
//  Created by Dominik Hel on 13.01.2022.

//  MARK: - Imports
import Foundation

//  MARK: - Class UserDefaultsStorage
final class UserDefaultsStorage {
    //  MARK: - Constants and variables
    static let shared = UserDefaultsStorage()
    private let userDefaults = UserDefaults.standard
    
    //  MARK: - Inits
    private init() {}

    //  MARK: - Functions
    func save(numberOfQuestions: Int, typesOfDifficulty: String) {
        userDefaults.set(numberOfQuestions, forKey: "numberOfQuestions")
        userDefaults.set(typesOfDifficulty, forKey: "typesOfDifficulty")
    }
    
    func loadNumberOfQuestions() -> Int{
        let numberOfQuestions = userDefaults.object(forKey: "numberOfQuestions") as? Int ?? 10
        return numberOfQuestions
    }
    
    func loadTypesOfDifficulty() -> String{
        let typesOfDifficulty = userDefaults.object(forKey: "typesOfDifficulty") as? String ?? "All"
        return typesOfDifficulty
    }
}
