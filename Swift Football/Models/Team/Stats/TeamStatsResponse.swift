//
//  TeamStatsResponse.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-24.
//

import Foundation

struct TeamStatsResponse: Decodable {
    let stats: TeamStats
    
    enum CodingKeys: String, CodingKey {
        case stats = "response"
    }
}
