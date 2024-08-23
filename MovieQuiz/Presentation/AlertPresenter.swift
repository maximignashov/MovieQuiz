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
    
    func show(quiz: QuizResultsViewModel?, comp: (() -> Void)?) {

        guard let quiz = quiz else {
            return
        }
        
        guard let comp = comp else {
            return
        }
        
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
        
        delegate?.present(alert, animated: true, completion: comp)
    }
}
