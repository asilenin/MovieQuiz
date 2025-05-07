import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private let statisticService: StatisticServiceProtocol!

    private var currentQuestion: QuizQuestion?
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func resetQuestionIndex() {
        correctAnswers = 0
        currentQuestionIndex = 0
    }
    
    private func switchToNextQuestion() {
        viewController?.showLoadingIndicator()
        currentQuestionIndex += 1
    }
    
    func enableTapOnButtons(_ isEnabled: Bool, noButton: UIButton, yesButton: UIButton){
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let isCorrect = isYes == currentQuestion.correctAnswer
        
        if (isCorrect) { correctAnswers += 1 }
        
        showAnswerResult(isCorrect: isCorrect )
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
            self?.viewController?.hideLoadingIndicator()
            self?.viewController?.enableTapOnButtons(true)
        }
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didFailToLoadImage() {
        let message = "Ошибка загрузки картинки"
        print(message)
        
        let alertContainer = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Перезапустить игру")
        
        viewController?.showAlert(model: alertContainer)
    }
    
    private func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: self.questionsAmount)
            
            //prepare message of result
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.YY HH:mm"
            let bestAttemptResultDate = dateFormatter.string(from: statisticService.bestGame.date)
            
            let totalAccuracy = statisticService.totalAccuracy * 100
            let formattedAccuracy = String(format: "%.2f", totalAccuracy)
            
            let resultText = "Ваш результат: \(correctAnswers)/\(self.questionsAmount)"
            let totalAttemptsPlayesText = "Количество сыгранных квизов: \(statisticService.gamesCount)"
            let bestAttemptResultText = "Рекорд: \(statisticService.bestGame.correct)/10 (\(bestAttemptResultDate))"
            let averageText = "Средняя точность: \(formattedAccuracy)%"
            
            let resultMessage = [resultText,
                                 totalAttemptsPlayesText,
                                 bestAttemptResultText,
                                 averageText].joined(separator: "\n")
            
            
            
            let resultsViewModel = AlertModel( // 2
                title: "Этот раунд окончен!",
                message: resultMessage,
                buttonText: "Сыграть ещё раз")
            
            viewController?.showAlert(model: resultsViewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showNetworkError(message: String) {
        
        print("Ошибка: \(message)")
        
        let alertContainer = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз")
        
        viewController?.showAlert(model: alertContainer)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        viewController?.showBorder(isCorrect: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    func restartGame() {
        questionFactory?.loadData()
        viewController?.showLoadingIndicator()
        resetQuestionIndex()
        questionFactory?.requestNextQuestion()
    }
}
