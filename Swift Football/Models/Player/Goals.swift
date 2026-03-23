//
//  Goals.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-18.
//

import Foundation

struct Goals: Decodable, Statistic {
    let total: Int?
    let conceded: Int?
    let assists: Int?
    let saves: Int?
}
