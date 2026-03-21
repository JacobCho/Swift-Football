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
    var players: [PlayerInfoContainer] = []
    private let teamsFetcher = TeamsFetcher()
    private let leaguesFetcher = LeaguesFetcher()
    private let playersFetcher = PlayersFetcher()
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
    
    func fetchTeamForDetail(id: Int) async {
        if loadState == .loading { return }
        loadState = .loading
        
        let predicate = #Predicate<TeamInfo> { $0.team.id == id }
        let sort: [SortDescriptor<TeamInfo>] = [SortDescriptor(\.id, order: .forward)]
        
        let savedTeams = await dataProvider.fetch(for: TeamInfo.self, predicate: predicate, sortBy: sort)
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
    
    func isTeamFavourited() -> Bool {
        return teamInfo?.isSelected ?? false
    }
    
    func saveTeamAsFavourite() {
        teamInfo?.isSelected.toggle()
        Task {
            await dataProvider.save()
        }
    }
    
    func fetchPlayerStats(team: Int, season: Int, page: Int? = 1) async {
        do {
            let response: PlayerResponse = try await playersFetcher.fetchPlayersStatistics(season: season, team: team, page: page)
            
            mergePlayersWithoutDuplicates(newPlayers: response.players)
            if response.paging.current < response.paging.total {
                await fetchPlayerStats(team: team, season: season, page: response.paging.current + 1)
            }
        } catch {
            loadState = .error(error.localizedDescription)
        }
    }
    
    func mergePlayersWithoutDuplicates(newPlayers: [PlayerInfoContainer]) {
        let existingIDs = Set(players.map(\.player.id))
        let uniqueNewPlayers = newPlayers.filter { !existingIDs.contains($0.player.id) }
        players.append(contentsOf: uniqueNewPlayers)
    }
    
    func getPlayerPositions() -> [Position] {
        return [.goalkeeper, .defender, .midfielder, .attacker, .forward]
    }
    
    func getPlayers(for position: Position) -> [PlayerInfoContainer] {
        players.filter { $0.statistics.first?.games.position == position }.sorted {
            $0.getAllApps() > $1.getAllApps()
        }
    }
    
    
}
