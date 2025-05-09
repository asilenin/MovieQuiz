protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func show(quiz step: QuizStepViewModel)
    
    func showAlert(model: AlertModel)
    
    func showLoadingIndicator()
    
    func hideLoadingIndicator()
    
    func enableTapOnButtons (_ isEnabled: Bool)
    
    func restartQuiz()
    
    func showBorder(isCorrect: Bool)
}
