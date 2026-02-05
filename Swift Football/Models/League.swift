//
//  League.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import Foundation

enum LeagueType: String, Decodable {
    case league = "League"
    case cup = "Cup"
}

struct League: Identifiable, Decodable, LogoListable, Hashable {
    let id: Int
    let name: String?
    let type: LeagueType?
    let logo: String?
    let country: String?
    let flag: String?
    let season: Int?
    let standings: [[Standing]]?
}
