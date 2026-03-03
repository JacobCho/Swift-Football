//
//  LeaguesListRow.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-28.
//

import SwiftUI
import SwiftData

struct LeaguesListView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var viewModel: LeaguesViewModel
    let country: Country
    
    init(country: Country, dataProvider: SwiftDataProvider) {
        self.country = country
        let viewModel = LeaguesViewModel(dataProvider: dataProvider)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if viewModel.loadState != .finished {
                LoadStateView(loadState: viewModel.loadState, buttonAction: fetch)
            } else {
                List(viewModel.leagues) { league in
                    Button(action: {
                        toggleLeagueSelection(league: league)
                    }) {
                        LogoListRow(listable: league)
                            .frame(maxHeight: 30)
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                
                .listStyle(.plain)
                .listRowSpacing(10)
                .navigationBarTitle("Leagues")
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 10)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        CloseButton()
                            .environmentObject(coordinator)
                    }
                }            }
        }
        .task {
            fetch()
        }
    }
    
    func toggleLeagueSelection(league: League) {
        viewModel.toggleLeagueSelection(league: league)
    }
    
    func fetch() {
        Task {
            await viewModel.fetchLeagues(code: country.code ?? "")
        }
    }
}


