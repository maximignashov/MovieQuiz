//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Максим on 15.09.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private let statisticService: StatisticServiceProtocol!
    private var questionFactory: QuestionFactory?
    weak var viewController: MovieQuizViewControllerProtocol?
    private var currentQuestionIndex: Int = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    let questionsAmount: Int = 10
    var correctAnswers: Int = 0
    
    var currentQuestion: QuizQuestion?
    var alertPresenter = AlertPresenter()
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func yesButtonClick(answer: Bool, button: UIButton, nextButton: UIButton) {
        didAnswer(answer: answer,
                  button: button,
                  nextButton: nextButton
        )
    }
    
    func noButtonClick(answer: Bool, button: UIButton, nextButton: UIButton) {
        didAnswer(answer: answer,
                  button: button,
                  nextButton: nextButton
        )
    }
    
    func didAnswer(answer: Bool, button: UIButton, nextButton: UIButton) {
        
        if button.isEnabled {
            guard let currentQuestion = currentQuestion else {
                return
            }
            button.isEnabled = false
            proceedWithAnswer(isCorrect: answer == currentQuestion.correctAnswer,
                             button: button, nextButton: nextButton)
        }
    }
    
    private func proceedWithAnswer(isCorrect: Bool, button: UIButton, nextButton: UIButton) {
        didAnswer(isCorrectAnswer: isCorrect)

        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults(button: button, nextButton: nextButton)
        }
    }
    
    private func proceedToNextQuestionOrResults(button: UIButton, nextButton: UIButton) {
        if self.isLastQuestion() {
            
            let result = QuizResultsViewModel(
                            correctAnswers: correctAnswers,
                            questionsAmount: questionsAmount,
                            completion: { [weak self] in
                                guard let self else { return }
                                self.restartGame()
                            }
                        )
            alertPresenter.show(quiz: result, quizPresenter: self)
        
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
        button.isEnabled = true
        nextButton.isEnabled = true
    }
    
    // MARK: - QuestionFactoryDelegate
        
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers,
                               total: questionsAmount
                               )
        
        let bestGame = statisticService.bestGame
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
                
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMessage
    }
}
