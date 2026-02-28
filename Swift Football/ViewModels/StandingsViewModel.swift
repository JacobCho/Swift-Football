//
//  StandingsViewModel.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-03.
//

import Foundation
internal import Combine
import SwiftUI

struct StandingsDescriptionLegend: Identifiable {
    var id = UUID()
    let color: Color
    let description: String?
}

@MainActor
class StandingsViewModel: BaseViewModel {
    @Published var containers: [LeagueContainer] = []
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
    
    func colourForDescription(_ description: StandingDescription?) -> Color {
        guard let description else {
            return .clear
        }
        switch description {
        case .championsLeague, .copaLibertadores:
            return .yellow
        case .europaLeague:
            return .blue
        case .conferenceLeague:
            return .cyan
        case .relegation:
            return .red
        case .relegationPlayoff:
            return .brown
        case .promotion:
            return .green
        case .promotionPlayoffs:
            return .mint
        case .finals:
            return .orange
        case .nextRound:
            return .teal
        case .lowerTableRound:
            return .indigo
        case .other(_):
            return .gray
        }
    }
    
    func standingsDescriptionsLegend() -> [StandingsDescriptionLegend] {
        guard let flattened = flattenedStandings() else {
            return []
        }
        let filtered = flattened.compactMap { $0.description }
        let descriptionSet = Set(filtered)
        let sorted = descriptionSet.sorted { standing1, standing2 in
            switch (standing1, standing2) {
            case (.finals, _): return true
            case (_, .finals): return false
            case (.championsLeague, _): return true
            case (_, .championsLeague): return false
            case (.europaLeague, _): return true
            case (_, .europaLeague): return false
            case (.conferenceLeague, _): return true
            case (_, .conferenceLeague): return false
            case (.promotion, _): return true
            case (_, .promotion): return false
            case (.promotionPlayoffs, _): return true
            case (_, .promotionPlayoffs): return false
            case (.relegationPlayoff, _): return true
            case (_, .relegationPlayoff): return false
                
            default: return false
            }
        }
        return sorted.map { standing in
            StandingsDescriptionLegend(color: colourForDescription(standing), description: standing.description())
        }
    }
    
    func fetchStandings(league: Int? = nil, season: Int? = nil, team: Int? = nil) async {
        if loadState == .loading || loadState == .finished { return }
        loadState = .loading
        
        do {
            let response: StandingsResponse = try await standingsFetcher.fetchStandings(league: league, season: season, team: team)
            await MainActor.run {
                containers = response.containers
            }
        } catch {
            if let descError = error as? (any DescriptiveError) {
                loadState = .error(descError.description)
            }
        }
        loadingFinished(isEmpty: containers.count == 0)
    }
}
