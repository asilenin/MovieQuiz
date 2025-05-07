import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    private weak var viewController: UIViewController?
    
    weak var delegate: AlertPresenterDelegate?
    
    // MARK: - Initialization
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Public

        func show(model: AlertModel) {

            let alert = UIAlertController(
                title: model.title,
                message: model.message,
                preferredStyle: .alert)

            let action = UIAlertAction(
                title: model.buttonText,
                style: .default
            ) { [weak self] _ in
                guard let self else { return }
                self.delegate?.restartQuiz()
            }
            
            alert.view.accessibilityIdentifier = "Alert"
            alert.addAction(action)
            viewController?.present(alert, animated: true, completion: nil)
            
        }
    
}
