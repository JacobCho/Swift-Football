//
//  LeaguesViewModel.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-28.
//

import Foundation
internal import Combine
import SwiftData

class LeaguesViewModel: BaseViewModel {
    var leagues: [League] = []
    private let leaguesFetcher = LeaguesFetcher()
    private let dataProvider: SwiftDataProvider
    
    init(dataProvider: SwiftDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchLeagues(code: String) async {
        if loadState == .loading || loadState == .finished { return }
        loadState = .loading
        
        let predicate = #Predicate<League> { league in
            league.code == code
        }
        
        let savedLeagues = await dataProvider.fetch(for: League.self, predicate: predicate)
        
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
                await dataProvider.saveData(leagues)
            } catch {
                if let descError = error as? DescriptiveError  {
                    loadState = .error(descError.description)
                }
            }
        }
        loadingFinished(isEmpty: leagues.count == 0)
    }
}

