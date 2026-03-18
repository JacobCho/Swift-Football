//
//  Team.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-03.
//

import Foundation
import SwiftData

struct TeamDTO: Decodable, LogoListable, Hashable {
    let id: Int
    let name: String?
    let logo: String?
    let code: String?
    let country: String?
    let founded: Int?
    let national: Bool?
}

@Model
class Team: LogoListable {
    var id: Int
    var name: String?
    var logo: String?
    var code: String?
    var country: String?
    var founded: Int?
    var national: Bool?
    
    init(dto: TeamDTO) {
        self.id = dto.id
        self.name = dto.name
        self.code = dto.code
        self.logo = dto.logo
        self.country = dto.country
        self.founded = dto.founded
        self.national = dto.national
    }
}
