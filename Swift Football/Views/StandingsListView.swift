//
//  StandingsListView.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-30.
//

import SwiftUI

struct StandingsListView: View {
    @State private var viewModel = StandingsViewModel()
    let league: League
    
    var body: some View {
        VStack {
            if viewModel.loadState != .finished {
                LoadStateView(loadState: viewModel.loadState, buttonAction: fetch)
            } else {
                if let standings: [Standing] = viewModel.flattenedStandings(), standings.count > 0 {
                    VStack(spacing: -20) {
                        List {
                            Section {
                                ForEach(standings) { standing in
                                    StandingTeamCell(viewModel: viewModel, standing: standing)
                                }
                            } header: {
                                StandingsHeader()
                            }
                            
                            Section {
                                ForEach(viewModel.standingsDescriptionsLegend()) { legend in
                                    StandingDescriptionLegendCell(legend: legend)
                                }
                            }
                        }
                        .font(.system(size: 11))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .listRowSpacing(-25)
                        .listStyle(.insetGrouped)
                        .navigationBarTitle(viewModel.navTitle())
                        .navigationBarTitleDisplayMode(.inline)
                        .safeAreaInset(edge: .top) {
                            Color.clear.frame(height: 10)
                        }
                    }
                } else {
                    EmptyStateView()
                }
            }
        }
        .onAppear {
            fetch()
        }
    }
    
    func fetch() {
        Task {
            await viewModel.fetchStandings(league: league.id, season: 2024)
        }
    }
}

struct StandingsHeader: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        HStack {
            Text("Team")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 45)
            HStack {
                StandingsText(text: "PL")
                StandingsText(text: "W")
                StandingsText(text: "D")
                StandingsText(text: "L")
                StandingsText(text: "GD")
                StandingsText(text: "PTS")
            }
            .multilineTextAlignment(.center)
            .frame(alignment: .trailing)
            .padding(.trailing, 8)
        }
        .foregroundStyle(colorScheme == .light ? .black : .white)
        .font(.system(size: 11, weight: .semibold))
    }
}

struct StandingsText: View {
    let text: String
    
    var body: some View {
        Text(text)
            .frame(minWidth:22, maxWidth: 22)
    }
}

struct StandingDescriptionLegendCell: View {
    var legend: StandingsDescriptionLegend
    
    var body: some View {
        HStack {
            legend.color
                .clipShape(Circle())
                .frame(width: 20, height: 20)
            Text(legend.description ?? "")
                .font(.system(size: 11))
                .lineLimit(1)
        }
        .frame(maxHeight: 30)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

struct StandingTeamCell: View {
    var viewModel: StandingsViewModel
    var standing: Standing
    
    var body: some View {
        HStack {
            if let team = standing.team {
                viewModel.colourForDescription(standing.description)
                    .frame(maxWidth: 3)
                StandingsText(text: "\(standing.rank)")
                AsyncImage(url: URL(string:team.logo ?? "")) { result in
                    result.image?
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 20, height: 20)
                Text(team.name ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    StandingsText(text: viewModel.standingPlayed(standing))
                    StandingsText(text: viewModel.standingWins(standing))
                    StandingsText(text: viewModel.standingDraws(standing))
                    StandingsText(text: viewModel.standingLosses(standing))
                    StandingsText(text: viewModel.standingGD(standing))
                    StandingsText(text: viewModel.standingPoints(standing))
                }
                .multilineTextAlignment(.center)
                .frame(alignment: .trailing)
                .padding(.trailing, 8)
            }
        }
        .frame(height: 30)
        .minimumScaleFactor(0.8)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}
