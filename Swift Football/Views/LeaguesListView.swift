//
//  LeaguesListRow.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-28.
//

import SwiftUI

struct LeaguesListView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel = LeaguesViewModel()
    let country: Country
    
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
                            await viewModel.fetchLeagues(code: country.code)
                        }
                    }
                }
            } else {
                if viewModel.leagues.count == 0 {
                    Text("Nothing to display!")
                } else {
                    List(viewModel.leagues) { leagueDetails in
                        ZStack {
                            NavigationLink("", value: leagueDetails)
                            if let league = leagueDetails.league {
                                LogoListRow(listable: league)
                            }
                        }
                        .frame(maxHeight: 30)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .listRowSpacing(10)
                    .navigationBarTitle("Leagues")
                    .safeAreaInset(edge: .top) {
                        Color.clear.frame(height: 10)
                    }
                    .navigationDestination(for: LeagueDetails.self) { details in
                        coordinator.view(for: .standings(details: details))
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchLeagues(code: country.code)
            }
        }
    }
}


