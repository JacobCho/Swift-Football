//
//  LeaguesResponse.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-10.
//

import Foundation

struct LeaguesResponse: Decodable {
    var leaguesDetails: [LeagueDetails]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.leaguesDetails = try container.decode([LeagueDetails].self, forKey: .leagues)
        self.leaguesDetails = self.leaguesDetails.map { element in
            var detail = element
            if let id = element.league?.id {
                detail.id = id
            }
            detail.league?.code = element.country?.code
            return detail
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case leagues = "response"
    }
}
