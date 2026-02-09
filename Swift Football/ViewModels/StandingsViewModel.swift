//
//  StandingsViewModel.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-03.
//

import Foundation
internal import Combine

@MainActor
class StandingsViewModel: ObservableObject {
    @Published var containers: [LeagueContainer] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private let standingsFetcher = StandingsFetcher()
    
    func flattenedStandings() -> [Standing]? {
        guard let container = containers.first, let league = container.league, var standings = league.standings?.first else {
            return nil
        }
        standings = standings.map { standing in
            var newStanding = standing
            newStanding.id = standing.rank
            return newStanding
        }
        
        return standings
    }
    
    func navTitle() -> String {
        guard let league = containers.first?.league else {
            return ""
        }
        var name = ""
        var year = ""
        if let leagueName = league.name {
            name = leagueName
        }
        
        if let season = league.season {
            year = "\(season)"
        }
        return "\(name) Standings \(year)"
    }
    
    func standingPlayed(_ standing: Standing) -> String {
        guard let played = standing.all?.played else {
            return ""
        }
        
        return "\(played)"
    }
    
    func standingWins(_ standing: Standing) -> String {
        guard let wins = standing.all?.win else {
            return ""
        }
        
        return "\(wins)"
    }
    
    func standingDraws(_ standing: Standing) -> String {
        guard let draws = standing.all?.draw else {
            return ""
        }
        
        return "\(draws)"
    }
    
    func standingLosses(_ standing: Standing) -> String {
        guard let lose = standing.all?.lose else {
            return ""
        }
        
        return "\(lose)"
    }
    
    func standingGD(_ standing: Standing) -> String {
        guard let goalsDiff = standing.goalsDiff, let goals = standing.all?.goals else {
            return ""
        }
        let positive = (goals.goalsFor - goals.goalsAgainst) > 0 ? "+" : ""
        
        return "\(positive)\(goalsDiff)"
    }
    
    func standingPoints(_ standing: Standing) -> String {
        guard let points = standing.points else {
            return ""
        }
        return "\(points)"
    }
    
    func fetchStandings(league: Int? = nil, season: Int? = nil, team: Int? = nil) async {
        if isLoading { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let response: StandingsResponse = try await standingsFetcher.fetchStandings(league: league, season: season, team: team)
            await MainActor.run {
                containers = response.containers
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
