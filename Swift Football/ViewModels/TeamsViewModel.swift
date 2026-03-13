//
//  TeamViewModel.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-10.
//

import Foundation
import SwiftData

@Observable
class TeamsViewModel: BaseViewModel {
    var teamInfo: TeamInfo?
    var leagues: [LeagueDetails] = []
    private let teamsFetcher = TeamsFetcher()
    private let leaguesFetcher = LeaguesFetcher()
    private let dataProvider: SwiftDataProvider
    private var selectedSeason: Int
    
    init(dataProvider: SwiftDataProvider, selectedSeason: Int) {
        self.dataProvider = dataProvider
        self.selectedSeason = selectedSeason
    }
    
    func teamName() -> String {
        guard let info = teamInfo, let teamName = info.team.name else {
            return ""
        }
        
        return teamName
    }
    
    func subtitle() -> String {
        guard let info = teamInfo, let country = info.team.country, let founded = info.team.founded else {
            return ""
        }
        let year = "\(founded)".replacing(",", with: "")
        
        return "\(country) · Founded: \(year)"
    }
    
    func fetchTeamForDetail(id: Int? = nil) async {
        if loadState == .loading { return }
        loadState = .loading
        
        let sort: [SortDescriptor<TeamInfo>] = [SortDescriptor(\.id, order: .forward)]
        
        let savedTeams = await dataProvider.fetch(for: TeamInfo.self, sortBy: sort)
        if savedTeams.count > 0 {
            teamInfo = savedTeams.first
        } else {
            do {
                let response: TeamsResponse = try await teamsFetcher.fetchTeams(id: id)
                teamInfo = response.teams.map { TeamInfo(dto: $0) }.first
                if let teamInfo {
                    await dataProvider.saveData([teamInfo])
                }
            } catch {
                if let descError = error as? DescriptiveError  {
                    loadState = .error(descError.description)
                }
            }
        }
        loadingFinished(isEmpty: teamInfo == nil)
    }
    
    func fetchInvolvedLeagues(team: Int, season: Int) async {
        do {
            let response: LeaguesResponse = try await leaguesFetcher.fetchLeagues(season: season, team: team)
            leagues = response.leaguesDetails
        } catch {
            if let descError = error as? DescriptiveError  {
                loadState = .error(descError.description)
            }
        }
    }
}
