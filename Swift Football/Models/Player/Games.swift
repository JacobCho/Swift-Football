//
//  File.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-18.
//

import Foundation

enum Position: String, Codable {
    case goalkeeper = "Goalkeeper"
    case defender = "Defender"
    case midfielder = "Midfielder"
    case attacker = "Attacker"
    case forward = "Forward"
    
    func abbrv() -> String {
        switch self {
        case .goalkeeper:
            return "GK"
        case .defender:
            return "DF"
        case .midfielder:
            return "MF"
        case .attacker:
            return "ATK"
        case .forward:
            return "FW"
        }
        
    }
}

struct Games: Decodable, Statistic {
    let appearences: Int?
    let lineups: Int?
    let minutes: Int?
    let number: Int?
    let position: Position
    let rating: String?
    let captain: Bool
}
