//
//  StandingsViewModel.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-03.
//

import Foundation
import SwiftUI

struct StandingsDescriptionLegend: Identifiable {
    var id = UUID()
    var color: Color = .clear
    let description: String
    let tier: StandingsTier
    
    init(description: StandingDescription) {
        self.description = description.description()
        self.tier = description.getTier()
    }
}

class StandingsViewModel: BaseViewModel {
    var containers: [LeagueContainer] = []
    var standings: [[Standing]] = []
    var leagueDTO: LeagueDTO?
    private let standingsFetcher = StandingsFetcher()
    
    func navTitle() -> String {
        guard let league = leagueDTO else {
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
        switch description.getTier() {
        case .first:
            return .green
        case .second:
            return .blue
        case .third:
            return .cyan
        case .secondBottom:
            return .brown
        case .bottom:
            return .red
        case .none:
            return .gray
        }
    }
    
    func standingsDescriptionsLegend() -> [StandingsDescriptionLegend] {
        guard let firstStandings = standings.first else {
            return []
        }
        let filtered = firstStandings.compactMap { $0.description }
        let descriptionSet = Set(filtered)
        let legendArray: [StandingsDescriptionLegend] = descriptionSet.map {
            var legend = StandingsDescriptionLegend(description: $0)
            legend.color = colourForDescription($0)
            return legend
        }.sorted {
            $0.tier.rawValue < $1.tier.rawValue
        }
        
        return legendArray
    }
    
    func fetchStandings(league: Int? = nil, season: Int? = nil, team: Int? = nil) async {
        if loadState == .loading || loadState == .finished { return }
        loadState = .loading
        
        do {
            let response: StandingsResponse = try await standingsFetcher.fetchStandings(league: league, season: season, team: team)
            containers = response.containers
            leagueDTO = response.containers.first?.league
            standings = leagueDTO?.standings ?? []
        } catch {
            if let descError = error as? (any DescriptiveError) {
                loadState = .error(descError.description)
            }
        }
        loadingFinished(isEmpty: standings.count == 0)
    }
}
