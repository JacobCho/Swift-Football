//
//  Team.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-03.
//

import Foundation

struct Team: Decodable, LogoListable, Hashable {
    let id: Int
    let name: String?
    let logo: String?
}
