//
//  LeaguesListRow.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-28.
//

import SwiftUI
import SwiftData

struct LeaguesListView: View {
    @Environment(Coordinator.self) var coordinator: Coordinator
    @State private var viewModel: LeaguesViewModel
    @Query var leagues: [League]
    let countryCode: String
    
    init(countryCode: String, dataProvider: SwiftDataProvider) {
        self.countryCode = countryCode
        let viewModel = LeaguesViewModel(dataProvider: dataProvider)
        _viewModel = State(initialValue: viewModel)

        _leagues = Query(filter: viewModel.predicate(code: countryCode), sort: [SortDescriptor(\League.name, order: .forward)])
    }
    
    var body: some View {
        VStack {
            if viewModel.loadState != .finished {
                LoadStateView(loadState: viewModel.loadState, buttonAction: fetch)
            } else {
                List(leagues) { league in
                    if coordinator.leagueSelectable {
                        Button(action: {
                            toggleLeagueSelection(league: league)
                        }) {
                            LogoListRow(listable: league)
                                .frame(maxHeight: 30)
                        }
                        .buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    } else {
                        ZStack {
                            NavigationLink("", value: league)
                            LogoListRow(listable: league)
                                .frame(maxHeight: 30)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .listRowSpacing(10)
                .navigationBarTitle("Leagues")
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 10)
                }
                .navigationDestination(for: League.self) { league in
                    coordinator.view(for: .standings(league: league))
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        CloseButton()
                            .environment(coordinator)
                    }
                }
            }
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
            await viewModel.fetchLeagues(code: countryCode)
        }
    }
}


