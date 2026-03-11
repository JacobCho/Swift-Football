//
//  Venue.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-10.
//

import Foundation
import SwiftData

struct VenueDTO: Decodable {
    let id: Int
    let name: String?
    let address: String?
    let city: String?
    let capacity: Int?
    let surface: String?
    let image: String?
}

@Model
class Venue {
    var id: Int
    var name: String?
    var address: String?
    var city: String?
    var capacity: Int?
    var surface: String?
    var image: String?
    
    init(dto: VenueDTO) {
        self.id = dto.id
        self.name = dto.name
        self.address = dto.address
        self.city = dto.city
        self.capacity = dto.capacity
        self.surface = dto.surface
        self.image = dto.image
    }
}
