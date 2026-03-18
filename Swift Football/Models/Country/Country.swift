//
//  Country.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import Foundation
import SwiftData

struct CountryDTO: Identifiable, Decodable, Hashable, LogoListable {
    var id: Int = 0
    let name: String?
    let code: String?
    let logo: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case code
        case logo = "flag"
    }
}

@Model
class Country: LogoListable {
    var id: Int
    var name: String?
    var code: String?
    var logo: String?
    
    init(dto: CountryDTO) {
        self.id = dto.id
        self.name = dto.name
        self.code = dto.code
        self.logo = dto.logo
    }
}
