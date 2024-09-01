//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Максим on 22.08.2024.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    func show(quiz result: QuizResultsViewModel) {

        let statisticService = StatisticService()
        
        let isoDate = result.gameResult.date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        let currentDate = dateFormatter.string(from: isoDate)
        
        let model = AlertModel(
            title: "Этот раунд окончен!",
            message: "Ваш результат: \(result.correctAnswers)/\(result.questionsAmount)\n" +
            "Количество сыграных квизов: \(statisticService.gamesCount)\n" +
            "Рекорд: \(result.gameResult.correct)/\(result.questionsAmount) (\(currentDate))\n" +
            "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%",
            buttonText: "Сыграть ещё раз",
            completion: result.completion)
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
            style: .default
        ) { _ in
            alertModel.completion?()
        }
        alertVC.addAction(action)
        delegate?.show(alertController: alertVC)
        
        //        let action = UIAlertAction(title: alertModel.buttonText, style: .default) {
        //            [weak self] _ in
        //            guard let self = self else { return }
        //
        //            delegate?.currentQuestionIndex = 0
        //            delegate?.correctAnswers = 0
        //
        //            delegate?.questionFactory.requestNextQuestion()
        //        }
    }
}
