//
//  TeamPlayedStat.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-24.
//

import Foundation

struct TeamPlayedStat: Decodable {
    let home: String?
    let away: String?
    let total: String?
    
    enum CodingKeys: String, CodingKey {
        case home
        case away
        case total
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let homeInt = try? container.decodeIfPresent(Int.self, forKey: .home) {
            self.home = String(homeInt)
        } else {
            self.home = try? container.decodeIfPresent(String.self, forKey: .home)
        }
        if let awayInt = try? container.decodeIfPresent(Int.self, forKey: .away) {
            self.away = String(awayInt)
        } else {
            self.away = try? container.decodeIfPresent(String.self, forKey: .away)
        }
        if let totalInt = try? container.decodeIfPresent(Int.self, forKey: .total) {
            self.total = String(totalInt)
        } else {
            self.total = try? container.decodeIfPresent(String.self, forKey: .total)
        }
    }
}
