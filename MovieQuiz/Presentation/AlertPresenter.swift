//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Максим on 22.08.2024.
//

import Foundation
import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    private var presenter: MovieQuizPresenter?
    
    func show(quiz result: QuizResultsViewModel, quizPresenter presenter: MovieQuizPresenter) {
        
        self.presenter = presenter
        
        let message = presenter.makeResultsMessage()
        
        let model = AlertModel(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть ещё раз",
            completion: result.completion)
        show(model)
    }
    
    func showNetworkError(message: String) {
        
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз"
        ) {}
        show(model)
    }
    
    private func show(_ alertModel: AlertModel) {
        let alertVC = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default) { _ in
                alertModel.completion?()
        }
        alertVC.addAction(action)
        DispatchQueue.main.async {
            self.presenter?.viewController?.show(alertController: alertVC)
        }

    }
}
