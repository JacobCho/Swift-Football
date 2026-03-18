//
//  File.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-18.
//

import Foundation

struct Games: Decodable {
    let appearances: Int?
    let lineups: Int?
    let minutes: Int?
    let number: Int?
    let position: String
    let rating: String?
    let captain: Bool
}
