//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Anton Silenin on 21.04.2025.
//
import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    weak var viewController: UIViewController?
    weak var delegate: AlertPresenterDelegate?
    var questionFactory: QuestionFactoryProtocol?
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    
    func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.alertDidTap()
            //self.questionFactory?.requestNextQuestion()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
    
}
