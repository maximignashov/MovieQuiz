import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    public var questionFactory: QuestionFactory?
    
    public var alertPresenter: AlertPresenterProtocol = AlertPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        yesButton.isExclusiveTouch = true
        noButton.isExclusiveTouch = true
        
//        let questionFactory = QuestionFactory()
//        questionFactory.setup(delegate: self)
//        self.questionFactory = questionFactory
//        
//        questionFactory.requestNextQuestion()
        
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)

        showLoadingIndicator()
        questionFactory?.loadData()
        
        alertPresenter.delegate = self

    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - IB Outlets
    
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = true
        answerGived(answer: false, button: sender, nextButton: yesButton)
    }
    
    @IBAction private func yesButtonOnClicked(_ sender: UIButton) {
        yesButton.isEnabled = true
        noButton.isEnabled = false
        answerGived(answer: true, button: sender, nextButton: noButton)
    }
    
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    private var correctAnswers = 0
    private var currentQuestionIndex = 0
    private let questionsAmount = 10
    private var currentQuestion: QuizQuestion?
    private let statisticService = StatisticService()
    
    private func answerGived(answer: Bool, button: UIButton, nextButton: UIButton) {
        if button.isEnabled {
            guard let currentQuestion = currentQuestion else {
                return
            }
            button.isEnabled = false
            showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer,
                             button: button, nextButton: nextButton)
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func show(quiz step: QuizStepViewModel) {
        
        imageView.layer.borderWidth = 0
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool, button: UIButton, nextButton: UIButton) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults(button: button, nextButton: nextButton)
        }
    }
    
    private func showNextQuestionOrResults(button: UIButton, nextButton: UIButton) {
        
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(
                correct: correctAnswers,
                total: questionsAmount
            )
            let result = QuizResultsViewModel(
                correctAnswers: correctAnswers,
                questionsAmount: questionsAmount,
                gameResult: statisticService.bestGame,
                completion: { [weak self] in
                    guard let self else { return }
                    self.correctAnswers = 0
                    self.currentQuestionIndex = 0
                    self.questionFactory?.requestNextQuestion()
                }
            )
            alertPresenter.show(quiz: result)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            button.isEnabled = false
        }
        button.isEnabled = true
        nextButton.isEnabled = true
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        
        hideLoadingIndicator()
        
        self.correctAnswers = 0
        self.currentQuestionIndex = 0
        self.questionFactory?.requestNextQuestion()
        
        alertPresenter.showNetworkError(message: message)
        
    }
}

extension MovieQuizViewController: AlertPresenterDelegate {
    func show(alertController: UIAlertController) {
        present(alertController, animated: true)
    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
