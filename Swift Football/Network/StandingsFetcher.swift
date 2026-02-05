//
//  StandingsFetcher.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-03.
//

import Foundation
internal import Combine

struct StandingsResponse: Decodable {
    var containers: [LeagueContainer]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.containers = try container.decode([LeagueContainer].self, forKey: .containers)
    }
    
    enum CodingKeys: String, CodingKey {
        case containers = "response"
    }
}

enum StandingsError: Error {
    case missingParameters
}

class StandingsFetcher: DataFetcher {
    
    /// Parameters:
    /// league: id of the league
    /// season: Year of the season
    /// team: id of the team
    
    func fetchStandings(league: Int? = nil, season: Int? = nil, team: Int? = nil) async throws -> StandingsResponse {
        var parameters: [String: String] = [:]
    
        if league == nil && team == nil {
            throw StandingsError.missingParameters
        }
            
        if let league {
            parameters["league"] = "\(league)"
        }
        
        if let season {
            parameters["season"] = "\(season)"
        } else {
            throw StandingsError.missingParameters
        }
        
        if let team {
            parameters["team"] = "\(team)"
        }
        
        do {
            let response: StandingsResponse = try await self.fetch(endPoint: .standings, parameters: parameters)
            cachedResponse = response
            return response
        }  catch {
            print(error)
            throw NetworkError.decodingError(error)
        }
    }
}
