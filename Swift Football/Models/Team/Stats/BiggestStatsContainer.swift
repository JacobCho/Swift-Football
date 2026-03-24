//
//  BiggestStatsContainer.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-24.
//

import Foundation

struct BiggestStatsContainer: Decodable {
    let streak: StreakStat?
    let wins: ScoreStat?
    let loses: ScoreStat?
    let goals: BiggestGoalsContainer?
}
