//
//  GoalsPerMinsStatsContainer.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-24.
//

import Foundation

struct StatPerMinsContainer: Decodable {
    let first15: PercentageStat
    let second15: PercentageStat
    let third15: PercentageStat
    let fourth15: PercentageStat
    let fifth15: PercentageStat
    let sixth15: PercentageStat
    let seventh15: PercentageStat
    let eighth15: PercentageStat
    
    enum CodingKeys: String, CodingKey {
        case first15 = "0-15"
        case second15 = "16-30"
        case third15 = "31-45"
        case fourth15 = "46-60"
        case fifth15 = "61-75"
        case sixth15 = "76-90"
        case seventh15 = "91-105"
        case eighth15 = "106-120"
    }
}
