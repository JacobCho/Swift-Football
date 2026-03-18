//
//  PlayerResponse.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-18.
//

import Foundation

struct PlayerResponse: Decodable {
    let paging: Paging
    let players: [PlayerInfoContainer]
    
    enum CodingKeys: String, CodingKey {
        case paging
        case players = "response"
    }
}
