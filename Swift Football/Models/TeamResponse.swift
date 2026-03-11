//
//  TeamResponse.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-10.
//

import Foundation

struct TeamsResponse: Decodable {
    var teams: [TeamInfoDTO]
    
    enum CodingKeys: String, CodingKey {
        case teams = "response"
    }
}
