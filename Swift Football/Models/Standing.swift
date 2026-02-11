//
//  Standing.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-03.
//

import Foundation

enum StandingDescription: Decodable, Equatable, Hashable {
    case championsLeague
    case europaLeague
    case conferenceLeague
    case copaLibertadores
    case relegation
    case relegationPlayoff
    case promotion
    case promotionPlayoffs
    case finals
    case nextRound
    case lowerTableRound
    case other(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        let lowercased = rawValue.lowercased()
        
        if lowercased.contains("champions league") {
            self = .championsLeague
        } else if lowercased.contains("europa league") {
            self = .europaLeague
        } else if lowercased.contains("conference league") {
            self = .conferenceLeague
        } else if lowercased.contains("copa libertadores") {
            self = .copaLibertadores
        } else if lowercased.contains("relegation play") {
            self = .relegationPlayoff
        } else if lowercased.contains("relegation") {
            self = .relegation
        } else if lowercased.contains("promotion play") {
            self = .promotionPlayoffs
        } else if lowercased.contains("promotion") {
            self = .promotion
        } else if lowercased.contains("finals") {
            self = .finals
        } else if lowercased.contains("next round") {
            self = .nextRound
        } else if lowercased.contains("lower table round") {
            self = .lowerTableRound
        } else {
            self = .other(rawValue)
        }
    }
    
    func description() -> String {
        switch self {
        case .championsLeague:
            return "UEFA Champions League"
        case .europaLeague:
            return "UEFA Europa League"
        case .conferenceLeague:
            return "UEFA Conference League"
        case .copaLibertadores:
            return "Copa Libertadores"
        case .relegation:
            return "Relegation"
        case .relegationPlayoff:
            return "Relegation Playoffs"
        case .promotion:
            return "Promotion"
        case .promotionPlayoffs:
            return "Promotion Playoffs"
        case .finals:
            return "Finals"
        case .nextRound:
            return "Next Round"
        case .lowerTableRound:
            return "Lower Table Round"
        case .other:
            return "Other"
        }
    }
}

struct Standing: Identifiable, Decodable, Hashable {
    var id: Int = 0
    let rank: Int
    let team: Team?
    let points: Int?
    let goalsDiff: Int?
    let group: String?
    let form: String?
    let status: String?
    let description: StandingDescription?
    let all: PlayedStat?
    let home: PlayedStat?
    let away: PlayedStat?
    let update: String?
    
    enum CodingKeys: String, CodingKey {
        case rank
        case team
        case points
        case goalsDiff
        case group
        case form
        case status
        case description
        case all
        case home
        case away
        case update
    }
}
