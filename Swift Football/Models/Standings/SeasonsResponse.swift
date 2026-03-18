//
//  SeasonsResponse.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-09.
//

import Foundation

struct SeasonsResponse: Decodable {
    var seasons: [Int]
    
    enum CodingKeys: String, CodingKey {
        case seasons = "response"
    }
}
