//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Anton Silenin on 21.04.2025.
//
import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    private weak var viewController: UIViewController?
    
    private weak var delegate: AlertPresenterDelegate?
    
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    
    func show(quiz result: QuizResultsViewModel) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY HH:mm"
        let bestAttemptResultDate = dateFormatter.string(from: statisticService.bestGame.date)
        
        let totalAccuracy = statisticService.totalAccuracy * 100
        let formattedAccuracy = String(format: "%.2f", totalAccuracy)
        
        let totalAttemptsPlayesText = "Количество сыгранных квизов \(statisticService.gamesCount)"
        let bestAttemptResultText = "Рекорд \(statisticService.bestGame.correct) (\(bestAttemptResultDate))"
        let averageText = "Средняя точность \(formattedAccuracy)"
        
        let resultMessage = [result.text,
                             totalAttemptsPlayesText,
                             bestAttemptResultText,
                             averageText].joined(separator: "\n")
        
        let alert = UIAlertController(
            title: result.title,
            message: resultMessage,
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
