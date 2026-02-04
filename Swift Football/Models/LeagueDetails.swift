//
//  LeagueDetails.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import Foundation

struct LeagueDetails: Identifiable, Decodable {
    var id: Int = 0
    let league: League?
    let country: Country?
    let seasons: [Season]?
    
    enum CodingKeys: String, CodingKey {
        case league
        case country
        case seasons
    }
}


