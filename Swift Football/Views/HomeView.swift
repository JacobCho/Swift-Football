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
            List {
                ForEach(viewModel.sections, id: \.self) { section in
                    switch section {
                    case .leagues:
                        HomeFavouriteLeaguesSection(viewModel: viewModel, section: section, showSheet: showSheet)
                    case .teams:
                        HomeFavouriteTeamsSection(viewModel: viewModel, section: section, showSheet: showSheet)
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
            .navigationDestination(for: TeamInfo.self) { teamInfo in
                coordinator.view(for: .teamDetail(id: teamInfo.team.id, selectedSeason: 2024))
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
    }
    
    func showSheet(section: HomeSection) {
        coordinator.leagueSelectable = section == .leagues
        coordinator.isSheetPresented = true
    }
}

struct HomeFavouriteLeaguesSection: View {
    @EnvironmentObject var coordinator: Coordinator
    var viewModel: HomeViewModel
    var section: HomeSection
    @Query(filter: #Predicate<League> { $0.isSelected }) var leagues: [League]
    let showSheet: ((HomeSection) -> Void)
    
    var body: some View {
        Section(section.sectionTitle()) {
            ForEach(leagues) { league in
                ZStack {
                    NavigationLink("", value: league)
                    if let logoListable = viewModel.getLogoListableItem(for: section, item: league) {
                        LogoListRow(listable: logoListable, showSelectable: false)
                            .frame(maxHeight: 30)
                    }
                }
                .buttonStyle(.plain)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .onDelete(perform: deleteItem)
        }
        .sectionActions {
            Button("", systemImage: "plus.app") {
                showSheet(section)
            }
        }
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.last, let league = leagues[safe: index] else {
            return
        }
        league.isSelected.toggle()
    }
}

struct HomeFavouriteTeamsSection: View {
    var viewModel: HomeViewModel
    var section: HomeSection
    @Query(filter: #Predicate<TeamInfo> { $0.isSelected }) var teams: [TeamInfo]
    let showSheet: ((HomeSection) -> Void)

    var body: some View {
        Section(section.sectionTitle()) {
            ForEach(teams) { team in
                ZStack {
                    NavigationLink("", value: team)
                    if let logoListable = viewModel.getLogoListableItem(for: section, item: team) {
                        LogoListRow(listable: logoListable, showSelectable: false)
                            .frame(maxHeight: 30)
                    }
                }
                .buttonStyle(.plain)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .onDelete(perform: deleteItem)
        }
        .sectionActions {
            Button("", systemImage: "plus.app") {
                showSheet(section)
            }
        }
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.last, let team = teams[safe: index] else {
            return
        }
        team.isSelected.toggle()
    }
}
