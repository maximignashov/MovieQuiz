//
//  QuestionFsctoryDelegate.swift
//  MovieQuiz
//
//  Created by Максим on 20.08.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
