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
