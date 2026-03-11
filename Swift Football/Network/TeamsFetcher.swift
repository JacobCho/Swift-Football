//
//  TeamFetcher.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-10.
//

import Foundation

class TeamsFetcher: DataFetcher {
    
    /// Parameters:
    /// id: id of the team
    /// name: Name of the team
    /// code: Code of the team; 3 chars
    /// search: Name of the team
    /// country: The country name of the team
    /// league: id of the league
    /// season: Season of the team; Exactly 4 chars
    /// venue: id of the venue
    /// last: The X last leagues/cups added in API
    
    func fetchTeams(id: Int? = nil,
                   name: String? = nil,
                   code: String? = nil,
                   search: String? = nil,
                   country: String? = nil,
                   league: Int? = nil,
                   season: Int? = nil,
                   venue: Int? = nil) async throws -> TeamsResponse {
        var parameters: [String: String] = [:]
        
        if let id {
            parameters["id"] = "\(id)"
        }
        if let name {
            parameters["name"] = name
        }
        if let code, code.count == 3 {
            parameters["code"] = code
        }
        if let search {
            parameters["search"] = search
        }
        if let country {
            parameters["country"] = country
        }
        if let league {
            parameters["league"] = "\(league)"
        }
        if let season, "\(season)".count == 4 {
            parameters["season"] = "\(season)"
        }
        if let venue {
            parameters["venue"] = "\(venue)"
        }
        
        do {
            let response: TeamsResponse = try await self.fetch(endPoint: .teams, parameters: parameters)
            return response
        }  catch {
            throw error
        }
    }
}
