//
//  BiggestGoalsContainer.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-24.
//

import Foundation

struct BiggestGoalsContainer: Decodable {
    let goalsFor: HomeAwayGoalsStat
    let goalsAgainst: HomeAwayGoalsStat
    
    enum CodingKeys: String, CodingKey {
        case goalsFor = "for"
        case goalsAgainst = "against"
    }
}
