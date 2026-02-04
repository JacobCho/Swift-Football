//
//  Coverage.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import Foundation

struct Coverage: Decodable {
    let fixtures: Fixtures?
    let standings: Bool?
    let players: Bool?
    let topScorers: Bool?
    let topAssists: Bool?
    let topCards: Bool?
    let injuries: Bool?
    let predictions: Bool?
    let odds: Bool?
    
    enum CodingKeys: String, CodingKey {
        case fixtures, standings, players, injuries, predictions, odds
        case topScorers = "top_scorers"
        case topAssists = "top_assists"
        case topCards = "top_cards"
    }
}
