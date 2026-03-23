//
//  Dribbles.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-18.
//

import Foundation

struct Dribbles: Decodable, Statistic {
    let attempts: Int?
    let success: Int?
    let pass: Int?
}
