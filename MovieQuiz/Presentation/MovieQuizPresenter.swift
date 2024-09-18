//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Максим on 15.09.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
        
    private var questionFactory: QuestionFactory?
    private weak var viewController: MovieQuizViewController?
    private var currentQuestionIndex: Int = 0
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    let questionsAmount: Int = 10
    var correctAnswers: Int = 0
    
    var currentQuestion: QuizQuestion?
    var statisticService: StatisticService?
    var alertPresenter: AlertPresenterProtocol?
    
    let gameResult = GameResult(correct: 0, total: 0, date: Date())
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
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
            viewController?.showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer,
                             button: button, nextButton: nextButton)
        }
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
    
    func showNextQuestionOrResults(button: UIButton, nextButton: UIButton) {
        
        if self.isLastQuestion() {
            statisticService?.store(
                correct: correctAnswers,
                total: self.questionsAmount
            )
            let result = QuizResultsViewModel(
                correctAnswers: correctAnswers,
                questionsAmount: self.questionsAmount,
                gameResult: statisticService?.bestGame ?? gameResult,
                completion: { [weak self] in
                    guard let self else { return }
                    self.correctAnswers = 0
                    self.resetQuestionIndex()
                    questionFactory?.requestNextQuestion()
                }
            )
            alertPresenter?.show(quiz: result, quizPresenter: self)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
            button.isEnabled = false
        }
        button.isEnabled = true
        nextButton.isEnabled = true
    }
}
