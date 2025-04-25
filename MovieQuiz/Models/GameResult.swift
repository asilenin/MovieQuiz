//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Anton Silenin on 22.04.2025.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    // метод сравнения по количеству верных ответов
    func isBetterThan(_ another: GameResult) -> Bool {
            correct > another.correct
        }
}
