//
//  League.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import Foundation
import SwiftData

enum LeagueType: String, Codable {
    case league = "League"
    case cup = "Cup"
}

struct LeagueDTO: Identifiable, Decodable, LogoListable, Hashable {
    let id: Int
    let name: String?
    let type: LeagueType?
    let logo: String?
    let country: String?
    var code: String?
    let flag: String?
    let season: Int?
    let standings: [[Standing]]?
}

@Model
class League: LogoListable {
    var id: Int
    var name: String?
    var type: LeagueType?
    var logo: String?
    var country: String?
    var code: String?
    var flag: String?
    var season: Int?
    var isSelected: Bool
    
    init(dto: LeagueDTO) {
        self.id = dto.id
        self.name = dto.name
        self.type = dto.type
        self.logo = dto.logo
        self.country = dto.country
        self.code = dto.code
        self.flag = dto.flag
        self.season = dto.season
        self.isSelected = false
    }
}
