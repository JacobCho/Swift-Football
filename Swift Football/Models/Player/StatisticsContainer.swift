//
//  StatisticsContainer.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-18.
//

import Foundation

struct StatisticsContainer: Decodable {
    let team: TeamDTO
    let league: LeagueDTO
    let games: Games
    let substitutes: Substitutes
    let shots: Shots
    let goals: Goals
    let passes: Passes
    let tackles: Tackles
    let duels: Duels
    let dribbles: Dribbles
    let fouls: Fouls
    let cards: Cards
    let penalty: Penalty
    
    func getStatistic(stat: Statistics) -> Statistic {
        switch stat {
        case .team:
            return self.team
        case .league:
            return self.league
        case .games:
            return self.games
        case .substitutes:
            return self.substitutes
        case .shots:
            return self.shots
        case .goals:
            return self.goals
        case .passes:
            return self.passes
        case .tackles:
            return self.tackles
        case .duels:
            return self.duels
        case .dribbles:
            return self.dribbles
        case .fouls:
            return self.fouls
        case .cards:
            return self.cards
        case .penalty:
            return self.penalty
        }
    }
}
