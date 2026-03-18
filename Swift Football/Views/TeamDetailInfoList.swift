//
//  TeamDetailInfoList.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-17.
//

import Foundation
import SwiftUI

struct TeamDetailInfoList: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let detailInfo: TeamDetailInfo
    let viewModel: TeamsViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .foregroundStyle(backgroundColor())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            List {
                ForEach(detailInfo.sections(), id: \.rawValue) { section in
                    Section(section.sectionTitle()) {
                        switch section {
                        case .leagues:
                            ForEach(viewModel.leagues) { leagueDetails in
                                TeamInfoLeaguesList(leagueDetails: leagueDetails, listRowBackgroundColor: listRowBackgroundColor())
                            }
                        case .venue:
                            EmptyView()
                        case .players:
                            EmptyView()
                        case .teamStats:
                            EmptyView()
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .clipped()
        }
    }
    
    func listRowBackgroundColor() -> Color {
        return colorScheme == .light ? .white : Color(red: 0.20, green: 0.20, blue: 0.20)
    }
    
    func backgroundColor() -> Color {
        if colorScheme == .light {
            return Color(red: 0.91, green: 0.91, blue: 0.91)
        } else {
            return Color(red: 0.1, green: 0.1, blue: 0.1)
        }
    }
}

struct TeamInfoLeaguesList: View {
    let leagueDetails: LeagueDetails
    let listRowBackgroundColor: Color
    var body: some View {
        if let league = leagueDetails.league {
            LogoListRow(listable: league, showSelectable: false, backgroundColor: listRowBackgroundColor)
                .listRowBackground(listRowBackgroundColor)
                .frame(maxHeight: 30)
        }
    }
}
