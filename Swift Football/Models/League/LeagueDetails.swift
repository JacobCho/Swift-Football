//
//  LeagueDetails.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import Foundation

struct LeagueDetails: Identifiable, Decodable, Equatable, Hashable, Comparable {
    var id: Int = 0
    var league: LeagueDTO?
    let country: CountryDTO?
    let seasons: [Season]?
    
    enum CodingKeys: String, CodingKey {
        case league
        case country
        case seasons
    }
    
    static func == (lhs: LeagueDetails, rhs: LeagueDetails) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: LeagueDetails, rhs: LeagueDetails) -> Bool {
        return lhs.league?.type == .league
    }
    
    func isInTeamCountry(teamInfo: TeamInfo?) -> Bool {
        let teamCountry = teamInfo?.team.country?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let leagueCountry = self.country?.name?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard let teamCountry, let leagueCountry else {
            return false
        }

        return teamCountry == leagueCountry
    }
    
    func isLeagueType() -> Bool {
        return self.league?.type == .league
    }
    
    func hasStandings(for selectedSeason: Int) -> Bool {
        return season(for: selectedSeason)?.coverage?.standings == true
    }
    
    func season(for selectedSeason: Int) -> Season? {
        if let selectedSeasonMatch = self.seasons?.first(where: { $0.year == selectedSeason }) {
            return selectedSeasonMatch
        }

        return self.seasons?.first(where: { $0.current == true }) ?? self.seasons?.first
    }
    
    func lastsLongerThanOneMonth(selectedSeason: Int) -> Bool {
        guard
            let season = season(for: selectedSeason),
            let startDate = season.seasonDate(point: .start),
            let endDate = season.seasonDate(point: .end)
        else {
            return false
        }

        let duration = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        return duration > 30
    }
}


