//
//  PenaltyStats.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-24.
//

import Foundation

struct PenaltyStats: Decodable {
    let scored: PercentageStat?
    let missed: PercentageStat?
    let total: Int?
}
