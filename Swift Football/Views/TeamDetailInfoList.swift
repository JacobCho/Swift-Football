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
    @State var viewModel: TeamsViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .foregroundStyle(backgroundColor())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                if detailInfo == .teamStats {
                    HStack {
                        Spacer()
                        LeaguePicker(viewModel: $viewModel)
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 8)
                }
                List {
                    ForEach(detailInfo.sections(), id: \.rawValue) { section in
                        Section(section.sectionTitle()) {
                            switch section {
                            case .leagues:
                                if let error = viewModel.leaguesError {
                                    LoadStateView(loadState: .error(error.description), buttonAction: {
                                        refetchLeagues()
                                    })
                                } else {
                                    ForEach(viewModel.leagues) { leagueDetails in
                                        TeamInfoLeaguesList(leagueDetails: leagueDetails, listRowBackgroundColor: listRowBackgroundColor())
                                            .frame(maxHeight: 30)
                                    }
                                }
                            case .captain:
                                let captain = viewModel.getCaptain()
                                if captain.count > 0 {
                                    ForEach(captain, id: \.player.id) { captain in
                                        TeamInfoPlayersCell(playerInfo: captain, showAge: false)
                                            .frame(maxHeight: 30)
                                    }
                                }
                            case .venue:
                                TeamInfoVenueView(viewModel: viewModel)
                            case .players:
                                if let error = viewModel.playersError {
                                    LoadStateView(loadState: .error(error.description), buttonAction: {
                                        refetchPlayers()
                                    })
                                } else {
                                    TeamPlayersList(viewModel: viewModel, listRowBackgroundColor: listRowBackgroundColor())
                                }
                            case .teamRecord:
                                if let error = viewModel.teamStatsError {
                                    LoadStateView(loadState: .error(error.description), buttonAction: {
                                        refetchTeamStats()
                                    })
                                } else {
                                    if let stats = viewModel.teamStats {
                                        TeamRecordView(stats: stats)
                                    }
                                }
                            case .teamForm:
                                FormChart(data: viewModel.constructTeamForm())
                            case .playerStats:
                                EmptyView()
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .clipped()
            }
        }
    }
    
    func refetchLeagues() {
        Task {
            await viewModel.fetchInvolvedLeagues()
        }
    }
    
    func refetchPlayers() {
        Task {
            await viewModel.fetchPlayerStats()
        }
    }
    
    func refetchTeamStats() {
        Task {
            await viewModel.fetchTeamStats()
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

struct LeaguePicker: View {
    @Binding var viewModel: TeamsViewModel
    
    var body: some View {
        Menu {
            Picker(viewModel.selectedLeague?.league?.name ?? "", selection: $viewModel.selectedLeague) {
                ForEach(viewModel.leaguesForStats.enumerated(), id: \.element) { index, leagueDetails in
                    Text(leagueDetails.league?.name ?? "").tag(leagueDetails)
                }
            }
            .pickerStyle(.inline)
        } label: {
            if let leagueName = viewModel.selectedLeague?.league?.name {
                Label(leagueName, systemImage: "chevron.down")
                    .frame(maxHeight: 35)
                    .cornerRadius(8)
            }
        }
        .compositingGroup()
        .buttonStyle(.glass)
        .onChange(of: viewModel.selectedLeague) { oldValue, newValue in
            guard let newLeague = newValue else {
                return
            }
            viewModel.selectedLeague = newLeague
            Task {
                await viewModel.fetchTeamStats()
            }
        }
    }
}
