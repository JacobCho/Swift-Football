//
//  TeamInfoLeaguesList.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-19.
//

import Foundation
import SwiftUI

struct TeamInfoLeaguesList: View {
    let leagueDetails: LeagueDetails
    var body: some View {
        if let league = leagueDetails.league {
            LogoListRow(listable: league, showSelectable: false, backgroundColor: Color(.listRowBackground))
        }
    }
}
