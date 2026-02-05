//
//  LeaguesViewModel.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-28.
//

import Foundation
internal import Combine

@MainActor
class LeaguesViewModel: ObservableObject {
    @Published var leagues: [LeagueDetails] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private let leaguesFetcher = LeaguesFetcher()
    
    func fetchLeagues(id: Int? = nil,
                      name: String? = nil,
                      country: String? = nil,
                      code: String? = nil,
                      season: Int? = nil,
                      team: Int? = nil,
                      type: LeagueType? = nil,
                      current: Bool? = nil,
                      search: String? = nil,
                      last: Int? = nil) async {
        if isLoading { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let response: LeaguesResponse = try await leaguesFetcher.fetchLeagues(id: id,
                                                                                  name: name,
                                                                                  country: country,
                                                                                  code: code,
                                                                                  season: season,
                                                                                  team: team,
                                                                                  type: type,
                                                                                  current: current,
                                                                                  search: search,
                                                                                  last: last)
            await MainActor.run {
                leagues = response.leagues
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

