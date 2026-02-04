//
//  Fixtures.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import Foundation

struct Fixtures: Decodable {
    let events: Bool?
    let lineups: Bool?
    let statsFixtures: Bool?
    let statsPlayers: Bool?
    
    enum CodingKeys: String, CodingKey {
        case events
        case lineups
        case statsFixtures = "statistics_fixtures"
        case statsPlayers = "statistics_players"
    }
}
