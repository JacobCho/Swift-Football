//
//  HomeView.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-02.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var viewModel: HomeViewModel
    
    init(dataProvider: SwiftDataProvider) {
        let viewModel = HomeViewModel(dataProvider: dataProvider)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if viewModel.loadState != .finished {
                LoadStateView(loadState: viewModel.loadState, buttonAction: fetch)
            } else {
                List(viewModel.leagues) { league in
                    ZStack {
                        NavigationLink("", value: league)
                        LogoListRow(listable: league, showSelectable: false)
                            .frame(maxHeight: 30)
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                
                .listStyle(.plain)
                .listRowSpacing(10)
                .navigationBarTitle("Swift Football")
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 10)
                }
                .navigationDestination(for: League.self) { league in
                    coordinator.view(for: .standings(league: league))
                }
            }
        }
        .task {
            fetch()
        }
    }
    
    func fetch() {
        Task {
            await viewModel.fetchSelectedLeagues()
        }
    }
}
