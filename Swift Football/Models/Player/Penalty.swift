//
//  Penalty.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-18.
//

import Foundation

struct Penalty: Decodable {
    let won: Int?
    let comited: Int?
    let scored: Int?
    let missed: Int?
    let saved: Int?
}
