//
//  StatisticsContainer.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-18.
//

import Foundation

struct StatisticsContainer: Decodable {
    let team: TeamDTO
    let league: LeagueDTO
    let games: Games
    let substitutes: Substitutes
    let shots: Shots
    let passes: Passes
    let tackles: Tackles
    let duels: Duels
    let dribbles: Dribbles
    let fouls: Fouls
    let cards: Cards
    let penalty: Penalty
}
