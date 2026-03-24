//
//  TeamFixturesStat.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-24.
//

import Foundation

struct TeamFixturesStat: Decodable {
    let totalPlayed: TeamPlayedStat?
    let winsStat: TeamPlayedStat?
    let drawsStat: TeamPlayedStat?
    let losesStat: TeamPlayedStat?
    
    enum CodingKeys: String, CodingKey {
        case totalPlayed = "played"
        case winsStat = "wins"
        case drawsStat = "draws"
        case losesStat = "loses"
    }
}
