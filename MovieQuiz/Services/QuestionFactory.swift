//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Anton Silenin on 08.04.2025.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private weak var delegate: QuestionFactoryDelegate?
    
    private let questions = QuizQuestionMock.questions.shuffled()
    
    func requestNextQuestion() {
        guard let index = (0..<self.questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }

        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
    
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
}
