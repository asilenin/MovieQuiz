//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Anton Silenin on 09.04.2025.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
