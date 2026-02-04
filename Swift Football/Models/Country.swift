//
//  Country.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import Foundation

struct Country: Identifiable, Decodable, Hashable, LogoListable {
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
