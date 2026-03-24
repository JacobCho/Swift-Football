//
//  GoalsStat.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-24.
//

import Foundation

struct DetailedGoalsStat: Decodable {
    let total: TeamPlayedStat?
    let average: TeamPlayedStat?
    let goalsPerMin: StatPerMinsContainer?
    let underOverStats: UnderOverStatsContainer?
    
    enum CodingKeys: String, CodingKey {
        case total
        case average
        case goalsPerMin = "minute"
        case underOverStats = "under_over"
    }
}
