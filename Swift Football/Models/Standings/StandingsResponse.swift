//
//  StandingsResponse.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-09.
//

import Foundation

struct StandingsResponse: Decodable {
    var containers: [LeagueContainer]
    var error: StandingsErrorResponse?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.containers = try container.decode([LeagueContainer].self, forKey: .containers)
        self.error = try? container.decodeIfPresent(StandingsErrorResponse.self, forKey: .error)
    }
    
    enum CodingKeys: String, CodingKey {
        case containers = "response"
        case error = "errors"
    }
}
