//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Максим on 18.09.2024.
//

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(alertController: UIAlertController)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
