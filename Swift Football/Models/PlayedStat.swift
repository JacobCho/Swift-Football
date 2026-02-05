//
//  PlayedStat.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-03.
//

import Foundation

struct PlayedStat: Decodable, Hashable {
    let played: Int?
    let win: Int?
    let draw: Int?
    let lose: Int?
    let goals: GoalsStat?
}
