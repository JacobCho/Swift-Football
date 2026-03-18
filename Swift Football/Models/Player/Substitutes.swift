//
//  Substitues.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-18.
//

import Foundation

struct Substitutes: Decodable {
    let inAppearances: Int?
    let outAppearances: Int?
    let benchAppearances: Int?
    
    enum CodingKeys: String, CodingKey {
        case inAppearances = "in"
        case outAppearances = "out"
        case benchAppearances = "bench"
    }
}
