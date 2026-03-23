//
//  Cards.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-18.
//

import Foundation

struct Cards: Decodable, Statistic {
    let yellow: Int?
    let yellowRed: Int?
    let red: Int?
    
    enum CodingKeys: String, CodingKey {
        case yellow
        case yellowRed = "yellowred"
        case red
    }
}
