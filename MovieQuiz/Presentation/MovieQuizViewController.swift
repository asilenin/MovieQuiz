import UIKit

final class MovieQuizViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: currentQuestion)
        show(quiz: viewModel)
    }
    
    struct QuizQuestion {
      let image: String
      let text: String
      let correctAnswer: Bool
    }
    
    struct QuizStepViewModel {
      let image: UIImage
      let question: String
      let questionNumber: String
    }
    
    struct QuizResultsViewModel {
      let title: String
      let text: String
      let buttonText: String
    }

    private let questions: [QuizQuestion]  =    [
        QuizQuestion(
             image: "The Godfather",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true
        ),
        QuizQuestion(
             image: "The Dark Knight",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true
        ),
        QuizQuestion(
             image: "Kill Bill",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true
        ),
        QuizQuestion(
             image: "The Avengers",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true
        ),
        QuizQuestion(
             image: "Deadpool",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true
        ),
        QuizQuestion(
             image: "The Green Knight",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true
        ),
        QuizQuestion(
             image: "Old",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: false
        ),
        QuizQuestion(
             image: "The Ice Age Adventures of Buck Wild",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: false
        ),
        QuizQuestion(
             image: "Tesla",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: false
        ),
        QuizQuestion(
             image: "Vivarium",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: false
        )
     
    ]
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let currentQuestion = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.hideBoarder()
            self.showNextQuestionOrResults()
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
    
    private func showNextQuestionOrResults() {
    if currentQuestionIndex == questions.count - 1 {
        let viewModel = QuizResultsViewModel( // 2
        title: "Этот раунд окончен!",
        text: "Ваш результат \(correctAnswers)/\(questions.count)",
        buttonText: "Сыграть ещё раз")
        show(quiz: viewModel)
      } else {
        currentQuestionIndex += 1
        let nextQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: nextQuestion)
        show(quiz: viewModel)
      }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title:result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.isEnabled = true
        }
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.isEnabled = true
        }
    }
}
