import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    // MARK: - Properties
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private lazy var alertPresenter = AlertPresenter(viewController: self)
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter.delegate = self
        statisticService = StatisticService()
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        self.questionFactory?.requestNextQuestion()
    }
    
    
    // MARK: - Setup Methods
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let currentQuestion = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return currentQuestion
    }
    
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
    }
    
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect { correctAnswers += 1}
        self.showBorder(isCorrect: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.hideBoarder()
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let resultsViewModel = QuizResultsViewModel( // 2
            title: "Этот раунд окончен!",
            text: "Ваш результат \(correctAnswers)/\(questionsAmount)",
            buttonText: "Сыграть ещё раз")
            alertPresenter.show(quiz: resultsViewModel)
        } else {
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    func alertDidTap(){
        restartQuiz()
    }
    
    func restartQuiz(){
        currentQuestionIndex = 0
        correctAnswers = 0
        self.questionFactory?.requestNextQuestion()
    }

    func didReceiveNextQuestion(question: QuizQuestion?) {
        // проверка, что вопрос не nil
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
        
    private func showBorder(isCorrect: Bool){
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    private func hideBoarder(){
        imageView.layer.borderWidth = 0
    }
    
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.isEnabled = true
        }
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.isEnabled = true
        }
    }
    
}
