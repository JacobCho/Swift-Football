//
//  PlayersFetcher.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-18.
//

import Foundation

class PlayersFetcher: DataFetcher {
    
    /// Parameters:
    /// id: id of the player
    /// search: Name of the player
    /// league: id of the league
    /// season: Season of the player; Exactly 4 chars
    /// team: id of the team
    /// page: page number
    
    func fetchPlayersStatistics(id: Int? = nil,
                   search: String? = nil,
                   league: Int? = nil,
                   season: Int? = nil,
                   team: Int? = nil,
                   page: Int? = nil) async throws -> PlayerResponse {
        var parameters: [String: String] = [:]
        
        if let id {
            parameters["id"] = "\(id)"
        }
        if let search {
            parameters["search"] = search
        }
        if let league {
            parameters["league"] = "\(league)"
        }
        if let season, "\(season)".count == 4 {
            parameters["season"] = "\(season)"
        }
        if let team {
            parameters["team"] = "\(team)"
        }
        if let page {
            parameters["page"] = "\(page)"
        }
        
        do {
            let response: PlayerResponse = try await self.fetch(endPoint: .players, parameters: parameters)
            return response
        }  catch {
            throw error
        }
    }
}
