//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Максим on 23.08.2024.
//

import Foundation

protocol AlertPresenterProtocol {
    var delegate: AlertPresenterDelegate? { get set }
    func show(quiz result: QuizResultsViewModel)
}
