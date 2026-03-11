//
//  File.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import Foundation

class LeaguesFetcher: DataFetcher {
    
    /// Parameters:
    /// id: id of the league
    /// name: Name of the league
    /// country: The country name of the league
    /// code: Code of the league; 2 - 6 chars
    /// season: Season of the league; Exactly 4 chars
    /// team: id of the team
    /// type: type of the league
    /// current: state of the league
    /// search: Name of the league; >= 3 chars
    /// last: The X last leagues/cups added in API
    
    func fetchLeagues(id: Int? = nil,
                      name: String? = nil,
                      country: String? = nil,
                      code: String? = nil,
                      season: Int? = nil,
                      team: Int? = nil,
                      type: LeagueType? = nil,
                      current: Bool? = nil,
                      search: String? = nil,
                      last: Int? = nil) async throws -> LeaguesResponse {
        do {
            var parameters: [String: String] = [:]
            
            if let id {
                parameters["id"] = "\(id)"
            }
            if let name {
                parameters["name"] = name
            }
            if let country {
                parameters["country"] = country
            }
            if let code, code.count >= 2 && code.count <= 6 {
                parameters["code"] = code
            }
            if let season, "\(season)".count == 4 {
                parameters["season"] = "\(season)"
            }
            if let team {
                parameters["team"] = "\(team)"
            }
            if let type {
                parameters["type"] = type.rawValue
            }
            if let current {
                parameters["current"] = current ? "true" : "false"
            }
            if let search, search.count >= 3 {
                parameters["search"] = search
            }
            if let last {
                parameters["last"] = "\(last)"
            }
            
            let response: LeaguesResponse = try await self.fetch(endPoint: .leagues, parameters: parameters)
            return response
        } catch {
            throw error
        }
    }
}
