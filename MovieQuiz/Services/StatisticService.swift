//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Максим on 25.08.2024.
//

import Foundation

class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    
    private enum bestGameKeys: String {
        case correct
        case total
        case date
    }
    
    private enum Keys: String {
        case correct
        case gamesCount
    }
    
    var gamesCount: Int {
        get {
            storage.object(forKey: Keys.gamesCount.rawValue) as? Int ?? 1
        }
        
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    private var correctAnswers: Int {
        get {
            storage.object(forKey: Keys.correct.rawValue) as? Int ?? -1
        }
        
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let gameResult = GameResult(
                correct: storage.object(forKey: bestGameKeys.correct.rawValue) as? Int ?? -1,
                total: storage.object(forKey: bestGameKeys.total.rawValue) as? Int ?? -1,
                date: storage.object(forKey: bestGameKeys.date.rawValue) as? Date ?? Date() )
            return gameResult
        }
        set {
            storage.set(newValue.correct, forKey: bestGameKeys.correct.rawValue)
            storage.set(newValue.total, forKey: bestGameKeys.total.rawValue)
            storage.set(newValue.date, forKey: bestGameKeys.date.rawValue)
        }
    } 
    
    var totalAccuracy: Double {
        get {
            if correctAnswers != 0 {
                return Double(correctAnswers) / Double(gamesCount) * 100
            }
            return 0
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        self.gamesCount += 1
        
        let bestCorrectCount = storage.object(forKey: bestGameKeys.correct.rawValue) as? Int ?? -1
        
        if bestCorrectCount < count {
            storage.set(count, forKey: bestGameKeys.correct.rawValue)
        }
        
        let bestTotal = storage.object(forKey: bestGameKeys.total.rawValue) as? Int ?? -1
        
        if bestTotal < amount {
            storage.set(amount, forKey: bestGameKeys.total.rawValue)
        }
    }
}
