//
//  Tackles.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-18.
//

import Foundation

struct Tackles: Decodable, Statistic {
    let total: Int?
    let blocks: Int?
    let interceptions: Int?
}
