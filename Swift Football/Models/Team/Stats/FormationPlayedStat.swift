//
//  FormationPlayedStat.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-24.
//

import Foundation

struct FormationPlayedStat: Decodable {
    let formation: String
    let played: Int
    
    enum CodingKeys: CodingKey {
        case formation
        case played
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.formation = try container.decode(String.self, forKey: .formation)
        self.played = try container.decode(Int.self, forKey: .played)
    }
}
