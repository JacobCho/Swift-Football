//
//  LeaguesViewModel.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-28.
//

import Foundation
internal import Combine
import SwiftData

@MainActor
class LeaguesViewModel: BaseViewModel {
    @Published var leagues: [League] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private let leaguesFetcher = LeaguesFetcher()
    
    func fetchLeagues(code: String) async {
        if isLoading { return }
        isLoading = true
        errorMessage = nil
        
        let predicate = #Predicate<League> { league in
            league.code == code
        }
        
        let savedLeagues = fetch(for: League.self, predicate: predicate)
        
        if savedLeagues.count > 0 {
            leagues = savedLeagues
        } else {
            do {
                let response: LeaguesResponse = try await leaguesFetcher.fetchLeagues(code: code)
                leagues = response.leaguesDetails.compactMap { details in
                    guard let league = details.league else {
                        return nil
                    }
                    return League(dto: league)
                }
                saveData(leagues)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
        isLoading = false
    }
}

