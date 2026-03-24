//
//  TeamGoalsStat.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-24.
//

import Foundation

struct TeamGoalsStat: Decodable {
    let goalsFor: DetailedGoalsStat
    let goalsAgainst: DetailedGoalsStat
    
    enum CodingKeys: String, CodingKey {
        case goalsFor = "for"
        case goalsAgainst = "against"
    }
}
