//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Максим on 23.08.2024.
//

import Foundation

protocol AlertPresenterProtocol {
    func show(quiz: QuizResultsViewModel?, comp: (() -> Void)?)
}
