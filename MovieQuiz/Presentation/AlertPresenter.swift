//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Максим on 22.08.2024.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: MovieQuizViewController?
    
    func setup(delegate: MovieQuizViewController) {
        self.delegate = delegate
    }
    
    func show() {

        let model = AlertModel(
            title: "Этот раунд окончен!",
            message: delegate?.correctAnswers == delegate?.questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
                "Вы ответили на \(String(describing: delegate?.correctAnswers)) из 10, попробуйте ещё раз!",
            buttonText: "Сыграть ещё раз",
            completion: {})

        let quiz = QuizResultsViewModel(
            title: model.title,
            text: model.message,
            buttonText: model.buttonText)
        
        let alert = UIAlertController(
            
            title: quiz.title,
            message: quiz.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: quiz.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            delegate?.currentQuestionIndex = 0
            delegate?.correctAnswers = 0
            
            delegate?.questionFactory.requestNextQuestion()
        }
        
        alert.addAction(action)
        
        delegate?.present(alert, animated: true, completion: model.completion)
    }
}
