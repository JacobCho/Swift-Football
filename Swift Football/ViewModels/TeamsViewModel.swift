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
    var leaguesError: DescriptiveError?
    
    var players: [PlayerInfoContainer] = []
    var playersError: DescriptiveError?
    
    var teamStats: TeamStats?
    var teamStatsError: DescriptiveError?
    
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
    
    func fetchInvolvedLeagues(team: Int) async {
        do {
            leaguesError = nil
            let response: LeaguesResponse = try await leaguesFetcher.fetchLeagues(season: selectedSeason, team: team)
            leagues = orderLeagues(leagues: response.leaguesDetails)
        } catch {
            if let descError = error as? DescriptiveError  {
                leaguesError = descError
            }
        }
    }
    
    func fetchTeamStats(team: Int, league: Int) async {
        do {
            teamStatsError = nil
            let response: TeamStatsResponse = try await teamsFetcher.fetchTeamStats(team: team, league: league, season: selectedSeason)
            teamStats = response.stats
        } catch {
            if let descError = error as? DescriptiveError  {
                teamStatsError = descError
            }
        }
    }
    
    func orderLeagues(leagues: [LeagueDetails]) -> [LeagueDetails] {
        /// Priority of league sorting:
        /// 1. Competition lasts longer than 1 month
        /// 2. Competition is in same country as team
        /// 3. Competition is of league type
        /// 4. Competition can return standings from API
        return leagues.sorted { league1, league2 in
            let comparisons = [
                (league1.lastsLongerThanOneMonth(selectedSeason: selectedSeason), league2.lastsLongerThanOneMonth(selectedSeason: selectedSeason)),
                (league1.isInTeamCountry(teamInfo: teamInfo), league2.isInTeamCountry(teamInfo: teamInfo)),
                (league1.isLeagueType(), league2.isLeagueType()),
                (league1.hasStandings(for: selectedSeason), league2.hasStandings(for: selectedSeason)),
            ]

            for comparison in comparisons where comparison.0 != comparison.1 {
                return comparison.0 && !comparison.1
            }

            let leftName = league1.league?.name ?? ""
            let rightName = league2.league?.name ?? ""
            if leftName != rightName {
                return leftName.localizedCaseInsensitiveCompare(rightName) == .orderedAscending
            }

            return league1.id < league2.id
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
    
    func fetchPlayerStats(team: Int, page: Int? = 1) async {
        do {
            playersError = nil
            let response: PlayerResponse = try await playersFetcher.fetchPlayersStatistics(season: selectedSeason, team: team, page: page)
            
            mergePlayersWithoutDuplicates(newPlayers: response.players)
            if response.paging.current < response.paging.total {
                await fetchPlayerStats(team: team, page: response.paging.current + 1)
            }
        } catch {
            if let descError = error as? DescriptiveError {
                playersError = descError
            }
        }
    }
    
    func mergePlayersWithoutDuplicates(newPlayers: [PlayerInfoContainer]) {
        let existingIDs = Set(players.map(\.player.id))
        let uniqueNewPlayers = newPlayers.filter { !existingIDs.contains($0.player.id) }
        players.append(contentsOf: uniqueNewPlayers)
    }
    
    func getCaptain() -> [PlayerInfoContainer] {
        return players.filter { $0.getStatsWithHighestApps()?.games.captain == true }
    }
    
    func getPlayerPositions() -> [Position] {
        return [.goalkeeper, .defender, .midfielder, .attacker, .forward]
    }
    
    func getPlayers(for position: Position) -> [PlayerInfoContainer] {
        return players.filter { $0.getStatsWithHighestApps()?.games.position == position }.sorted {
            $0.getAllApps() > $1.getAllApps()
        }
    }
    
    func getPlayersWithMostGoals(for league: LeagueDTO? = nil, limit: Int) -> [PlayerInfoContainer] {
        if let league {
            let sorted = players.sorted { player1, player2 in
                player1.getGoals(for: league) > player2.getGoals(for: league)
            }
            return Array(sorted.prefix(limit))
        } else {
            let sorted = players.sorted { player1, player2 in
                player1.getTotalGoals() > player2.getTotalGoals()
            }
            return Array(sorted.prefix(limit))
        }
    }
}
