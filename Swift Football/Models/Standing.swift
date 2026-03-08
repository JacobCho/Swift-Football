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
    case finalSeries
    case finalSeriesPlayoffs
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
        } else if lowercased.contains("final series play-offs") {
            self = .finalSeriesPlayoffs
        } else if lowercased.contains("final series") {
            self = .finalSeries
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
        case .finalSeries:
            return "Final Series"
        case .finalSeriesPlayoffs:
            return "Final Series Play-offs"
        case .nextRound:
            return "Next Round"
        case .lowerTableRound:
            return "Lower Table Round"
        case .other:
            return "Other"
        }
    }
    
    func getTier() -> StandingsTier {
        switch self {
        case .championsLeague, .copaLibertadores, .promotion, .finals, .finalSeries, .nextRound:
            return .first
        case .europaLeague, .promotionPlayoffs, .finalSeriesPlayoffs, .lowerTableRound:
            return .second
        case .conferenceLeague:
            return .third
        case .relegation:
            return .bottom
        case .relegationPlayoff:
            return .secondBottom
        case .other:
            return .none
        }
    }
}

enum StandingsTier: Int {
    case first = 0
    case second
    case third
    case secondBottom
    case bottom
    case none
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
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rank = try container.decode(Int.self, forKey: .rank)
        self.id = rank
        self.team = try container.decodeIfPresent(Team.self, forKey: .team)
        self.points = try container.decodeIfPresent(Int.self, forKey: .points)
        self.goalsDiff = try container.decodeIfPresent(Int.self, forKey: .goalsDiff)
        self.group = try container.decodeIfPresent(String.self, forKey: .group)
        self.form = try container.decodeIfPresent(String.self, forKey: .form)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.description = try container.decodeIfPresent(StandingDescription.self, forKey: .description)
        self.all = try container.decodeIfPresent(PlayedStat.self, forKey: .all)
        self.home = try container.decodeIfPresent(PlayedStat.self, forKey: .home)
        self.away = try container.decodeIfPresent(PlayedStat.self, forKey: .away)
        self.update = try container.decodeIfPresent(String.self, forKey: .update)
    }
}
