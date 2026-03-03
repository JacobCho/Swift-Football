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
            if viewModel.loadState == .empty {
                HomeEmptyStateView(buttonAction: showSheet)
            } else if viewModel.loadState != .finished && viewModel.loadState != .refetching {
                LoadStateView(loadState: viewModel.loadState, buttonAction: fetch)
            } else {
                List {
                    Section("Favourite Leagues") {
                        ForEach(viewModel.leagues) { league in
                            ZStack {
                                NavigationLink("", value: league)
                                LogoListRow(listable: league, showSelectable: false)
                                    .frame(maxHeight: 30)
                            }
                            .buttonStyle(.plain)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteLeague)
                    }
                    .sectionActions {
                        Button("", systemImage: "plus.app") {
                            showSheet()
                        }
                    }
                    .listSectionSeparator(.hidden)
                }
                .listStyle(.plain)
                .listRowSpacing(10)
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 10)
                }
                .navigationDestination(for: League.self) { league in
                    coordinator.view(for: .standings(league: league))
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Image("NavBarIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        })
        .navigationTitle("Swift Football")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: coordinator.isSheetPresented) { oldState, newState in
            if newState == false {
                viewModel.loadState = .refetching
                fetch()
            }
        }
        .task {
            fetch()
        }
    }
    
    func deleteLeague(indexSet: IndexSet) {
        guard let index = indexSet.last else {
            return
        }
        viewModel.deleteSelected(index: index)
    }
    
    func fetch() {
        Task {
            await viewModel.fetchSelectedLeagues()
        }
    }
    
    func showSheet() {
        coordinator.isSheetPresented = true
    }
}

struct HomeEmptyStateView: View {
    var buttonAction: (() -> Void)
    
    var body: some View {
        ContentUnavailableView {
            Label("No Favourited Leagues", systemImage: "star.slash")
        } description: {
            Text("Favourited Leagues will be shown here")
        } actions: {
            Button("Add Leagues") {
                buttonAction()
            }
        }
    }
}
