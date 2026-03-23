//
//  PlayerInfoContainer.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-18.
//

import Foundation

struct PlayerInfoContainer: Decodable {
    let player: Player
    let statistics: [StatisticsContainer]
    
    func getAllApps() -> Int {
        return self.statistics.reduce(0) { accumulator, statistics in
            if let appearences = statistics.games.appearences {
                return accumulator + appearences
            }
            return accumulator
        }
    }
    
    func getStatsWithHighestApps() -> StatisticsContainer? {
        return self.statistics.max { $0.games.appearences ?? 0 < $1.games.appearences ?? 0 }
    }
    
    func getContainer(for league: LeagueDTO) -> StatisticsContainer? {
        for statistic in statistics {
            if statistic.league.id == league.id {
                return statistic
            }
        }
        
        return nil
    }
    
    func getTotalGoals() -> Int {
        return self.statistics.reduce(0) { accumulator, statistics in
            if let goals = statistics.goals.total {
                return accumulator + goals
            }
            return accumulator
        }
    }
    
    func getGoals(for league: LeagueDTO) -> Int {
        let container = getContainer(for: league)
        
        return container?.goals.total ?? 0
    }
}
