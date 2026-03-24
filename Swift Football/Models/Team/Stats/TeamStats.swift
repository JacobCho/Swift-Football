//
//  TeamStats.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-24.
//

import Foundation

struct TeamStats: Decodable {
    let league: LeagueDTO?
    let team: TeamDTO?
    let form: String?
    let fixtures: TeamFixturesStat?
    let goals: TeamGoalsStat?
    let biggest: BiggestStatsContainer?
    let cleanSheet: TeamPlayedStat?
    let failedToScore: TeamPlayedStat?
    let penalties: PenaltyStats?
    let lineups: [FormationPlayedStat]?
    let cards: CardsStatsContainer?
    
    enum CodingKeys: String, CodingKey {
        case league
        case team
        case form
        case fixtures
        case goals
        case biggest
        case cleanSheet = "clean_sheet"
        case failedToScore = "failed_to_score"
        case penalties = "penalty"
        case lineups
        case cards
    }
}
