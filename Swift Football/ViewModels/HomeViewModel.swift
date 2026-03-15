//
//  HomeViewModel.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-02.
//

import Foundation
import SwiftData

enum HomeSection {
    case leagues
    case teams
    
    func sectionTitle() -> String {
        switch self {
        case .leagues:
            return "Favourite Leagues"
        case .teams:
            return "Favourite Teams"
        }
    }
}

@Observable
class HomeViewModel: BaseViewModel {
    var sections: [HomeSection] = [.leagues, .teams]
    var leagues: [League] = []
    var teams: [TeamInfo] = []
    private let dataProvider: SwiftDataProvider
    
    
    init(dataProvider: SwiftDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func getItems(for section: HomeSection) -> [any PersistentModel] {
        switch section {
        case .leagues:
            return leagues
        case .teams:
            return teams
        }
    }
    
    func getLogoListableItem(for section: HomeSection, item: any PersistentModel) -> LogoListable? {
        switch section {
        case .leagues:
            if let league = item as? League {
                return league
            }
        case .teams:
            if let teamInfo = item as? TeamInfo {
                return teamInfo.team
            }
        }
        return nil
    }
    
    func fetchSelected() {
        if loadState == .loading || loadState == .finished { return }
        loadState = .loading
        
        Task {
            await fetchedSavedLeagues()
            await fetchSavedTeams()
            
            loadingFinished(isEmpty: leagues.count == 0 && teams.count == 0)
        }
        
    }
    
    func deleteSelected(in section: HomeSection, index: Int) {
        switch section {
        case .leagues:
            guard let league = leagues[safe: index] else {
                return
            }
            leagues.remove(at: index)
            league.isSelected = false
        case .teams:
            guard let teamInfo = teams[safe: index] else {
                return
            }
            teams.remove(at: index)
            teamInfo.isSelected = false
        }
        Task {
            await dataProvider.save()
        }
        if leagues.count == 0 && teams.count == 0 {
            loadState = .empty
        }
    }
    
    private func fetchedSavedLeagues() async {
        let leaguePredicate = #Predicate<League> { league in
            league.isSelected
        }
        let savedLeagues = await dataProvider.fetch(for: League.self, predicate: leaguePredicate)
        
        if savedLeagues.count > 0 {
            leagues = savedLeagues
        }
        
    }
    
    private func fetchSavedTeams() async {
        let teamPredicate = #Predicate<TeamInfo> { teamInfo in
            teamInfo.isSelected
        }
        
        let savedTeams = await dataProvider.fetch(for: TeamInfo.self, predicate: teamPredicate)
        
        if savedTeams.count > 0 {
            teams = savedTeams
        }
    }
}
