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
    private let teamsFetcher = TeamsFetcher()
    private let dataProvider: SwiftDataProvider
    
    init(dataProvider: SwiftDataProvider) {
        self.dataProvider = dataProvider
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
}
