//
//  QuizResultsViewModel.swift
//  MovieQuiz
//
//  Created by Максим on 15.08.2024.
//

import Foundation

struct QuizResultsViewModel {
    let correctAnswers: Int
    let questionsAmount: Int
    
    let completion: () -> Void
}
