//
//  TeamContainer.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-10.
//

import Foundation
import SwiftData

struct TeamInfoDTO: Decodable {
    let team: TeamDTO
    let venue: VenueDTO
}

@Model
class TeamInfo {
    var team: Team
    var venue: Venue
    var isSelected: Bool
    
    init(dto: TeamInfoDTO) {
        self.team = Team(dto: dto.team)
        self.venue = Venue(dto: dto.venue)
        self.isSelected = false
    }
}
