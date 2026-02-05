//
//  Standing.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-03.
//

import Foundation

struct Standing: Identifiable, Decodable, Hashable {
    var id: Int = 0
    let rank: Int
    let team: Team?
    let points: Int?
    let goalsDiff: Int?
    let group: String?
    let form: String?
    let status: String?
    let description: String?
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
