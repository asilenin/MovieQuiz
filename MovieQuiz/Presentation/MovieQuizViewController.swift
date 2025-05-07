import UIKit


final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, AlertPresenterDelegate {
    
    // MARK: - Properties
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    lazy var alertPresenter = AlertPresenter(viewController: self)
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter.delegate = self
        presenter = MovieQuizPresenter(viewController: self)
        
        showLoadingIndicator()
    }
    
    // MARK: - Setup Methods
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
    }
    
    func showAlert(model: AlertModel){
        alertPresenter.show(model: model)
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func enableTapOnButtons (_ isEnabled: Bool) {
        presenter.enableTapOnButtons(isEnabled, noButton: noButton, yesButton: yesButton)
    }
    
    
    func restartQuiz(){
        presenter.restartGame()
    }
    
    func showBorder(isCorrect: Bool){
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        enableTapOnButtons(false)
        
        presenter.yesButtonClicked()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.isEnabled = true
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        enableTapOnButtons(false)
        
        presenter.noButtonClicked()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.isEnabled = true
        }
    }
}
