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
    }
    
    private enum Keys: String {
        case correct
        case gamesCount
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    private var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correct.rawValue)
        }
        
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let gameResult = GameResult(
                correct: storage.integer(forKey: bestGameKeys.correct.rawValue),
                total: storage.integer(forKey: bestGameKeys.total.rawValue),
                date: storage.object(forKey: "bestGameKeys.date") as? Date ?? Date() )
            return gameResult
        }
        set {
            storage.set(newValue.correct, forKey: bestGameKeys.correct.rawValue)
            storage.set(newValue.total, forKey: bestGameKeys.total.rawValue)
            storage.set(newValue.date, forKey: "bestGame.date")
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
        let bestCorrectCount = storage.integer(forKey: bestGameKeys.correct.rawValue)
        
        if bestCorrectCount < count {
            storage.set(count, forKey: bestGameKeys.correct.rawValue)
        }
        
        let bestTotal = storage.integer(forKey: bestGameKeys.total.rawValue)
        
        if bestTotal < amount {
            storage.set(amount, forKey: bestGameKeys.total.rawValue)
        }
    }
    
    init(bestGame: GameResult, totalAccuracy: Double) {
        self.bestGame = bestGame
    }
    
}
