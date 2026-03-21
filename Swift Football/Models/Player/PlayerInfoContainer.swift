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
        return self.statistics.max { $0.games.appearences ?? 0 > $1.games.appearences ?? 0 }
    }
}
