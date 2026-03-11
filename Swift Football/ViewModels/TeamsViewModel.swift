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
    var team: TeamInfo?
    private let teamsFetcher = TeamsFetcher()
    private let dataProvider: SwiftDataProvider
    
    init(dataProvider: SwiftDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchTeamForDetail(id: Int? = nil) async {
        if loadState == .loading { return }
        loadState = .loading
        
        let sort: [SortDescriptor<TeamInfo>] = [SortDescriptor(\.id, order: .forward)]
        
        let savedTeams = await dataProvider.fetch(for: TeamInfo.self, sortBy: sort)
        if savedTeams.count > 0 {
            team = savedTeams.first
        } else {
            do {
                let response: TeamsResponse = try await teamsFetcher.fetchTeams(id: id)
                team = response.teams.map { TeamInfo(dto: $0) }.first
                if let team {
                    await dataProvider.saveData([team])
                }
            } catch {
                if let descError = error as? DescriptiveError  {
                    loadState = .error(descError.description)
                }
            }
        }
        loadingFinished(isEmpty: team == nil)
    }
}
