//
//  StandingsListView.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-30.
//

import SwiftUI

struct StandingsListView: View {
    @StateObject var viewModel = StandingsViewModel()
    let leagueDetails: LeagueDetails
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                VStack {
                    Text(error)
                        .foregroundColor(.red)
                    Button("Retry") {
                        Task {
                            await viewModel.fetchStandings(league: leagueDetails.id, season: 2024)
                        }
                    }
                }
            } else {
                if let standings: [Standing] = viewModel.flattenedStandings(), standings.count > 0 {
                    VStack(spacing: -20) {
                        HStack {
                            Text("Team")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 25)
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
                            .padding(.trailing, 25)
                        }
                        .font(.system(size: 11, weight: .semibold))
                        List(standings) { standing in
                            HStack {
                                if let team = standing.team {
                                    AsyncImage(url: URL(string:team.logo ?? "")) { result in
                                        result.image?
                                            .resizable()
                                            .scaledToFit()
                                    }
                                    .frame(width: 20, height: 20)
                                    .padding(.leading, 8)
                                    Text(team.name ?? "")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 8)
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
                            .font(.system(size: 11))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .listStyle(.plain)
                        .listRowSpacing(-20)
                        .navigationBarTitle(viewModel.navTitle())
                        .navigationBarTitleDisplayMode(.inline)
                        .safeAreaInset(edge: .top) {
                            Color.clear.frame(height: 10)
                        }
                    }
                } else {
                    Text("Nothing to display!")
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchStandings(league: leagueDetails.id, season: 2024)
            }
        }
    }
}

struct StandingsText: View {
    let text: String
    
    var body: some View {
        Text(text)
            .frame(minWidth:22, maxWidth: 22)
    }
}
