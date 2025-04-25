//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Anton Silenin on 22.04.2025.
//

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
