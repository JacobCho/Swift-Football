//
//  GoalsStat.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-03.
//

import Foundation

struct GoalsStat: Decodable, Hashable {
    let goalsFor: Int
    let goalsAgainst: Int
    
    enum CodingKeys: String, CodingKey {
        case goalsFor = "for"
        case goalsAgainst = "against"
    }
}
