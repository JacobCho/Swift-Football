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
                                    .frame(maxHeight: 30)
                            }
                        case .captain:
                            ForEach(viewModel.getCaptain(), id: \.player.id) { captain in
                                TeamInfoPlayersCell(playerInfo: captain, showAge: false)
                                    .frame(maxHeight: 30)
                            }
                        case .venue:
                            TeamInfoVenueView(viewModel: viewModel)
                        case .players:
                            ForEach(viewModel.getPlayerPositions(), id: \.rawValue) { position in
                                DisclosureGroup(position.rawValue) {
                                    ForEach(viewModel.getPlayers(for: position), id: \.player.id) { playerInfo in
                                        TeamInfoPlayersCell(playerInfo: playerInfo)
                                            .frame(maxHeight: 30)
                                    }
                                }
                                .disclosureGroupStyle(GroupStyle())
                                .listRowBackground(listRowBackgroundColor())
                            }
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

struct GroupStyle: DisclosureGroupStyle {

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .font(.system(size: 16.0, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Age")
                .font(.system(size: 12, weight: .semibold))
                .frame(alignment: .trailing)
                .padding(.trailing, 10)
        }
        .onTapGesture {
            withAnimation {
                configuration.isExpanded.toggle()
            }
        }
        if configuration.isExpanded {
            configuration.content
                .padding(.leading, 8)
                .disclosureGroupStyle(self)
        }
    }
}
