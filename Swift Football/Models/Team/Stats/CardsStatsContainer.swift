//
//  CardsStatsContainer.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-24.
//

import Foundation

struct CardsStatsContainer: Decodable {
    let yellow: StatPerMinsContainer
    let red: StatPerMinsContainer
}
