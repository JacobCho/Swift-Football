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
                if let standings = viewModel.flattenedStandings() {
                    List(standings) { standing in
                        ZStack {
                            NavigationLink(destination: EmptyView()) {
                                EmptyView()
                            }
                            if let team = standing.team {
                                Text("\(team.name)")
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .listRowSpacing(-20)
                    .navigationBarTitle("Leagues")
                    .safeAreaInset(edge: .top) {
                        Color.clear.frame(height: 10)
                    }
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
