//
//  LeaguesListRow.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-28.
//

import SwiftUI

struct LeaguesListView: View {
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
                List(viewModel.leagues) { leagueDetails in
                    ZStack {
                        NavigationLink(destination: EmptyView()) {
                            EmptyView()
                        }
                        if let league = leagueDetails.league {
                            LogoListRow(listable: league)
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
        .onAppear {
            Task {
                await viewModel.fetchLeagues(code: country.code)
            }
        }
    }
}


