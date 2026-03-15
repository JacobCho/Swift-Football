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
        let _ = Self._printChanges()
        VStack {
            switch viewModel.loadState {
            case .loading, .error:
                LoadStateView(loadState: viewModel.loadState, buttonAction: fetch)
            default:
                if viewModel.loadState == .empty {
                    Text("Favourited Leagues and Teams will be shown here")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.top, 16)
                }
                List {
                    ForEach(viewModel.sections, id: \.self) { section in
                        HomeFavouritesSection(viewModel: viewModel, section: section)
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
        .task {
            fetch()
        }
    }
    
    func fetch() {
        viewModel.fetchSelected()
    }
    
    
}

struct HomeFavouritesSection: View {
    @EnvironmentObject var coordinator: Coordinator
    var viewModel: HomeViewModel
    var section: HomeSection
    
    init(viewModel: HomeViewModel, section: HomeSection) {
        self.viewModel = viewModel
        self.section = section
    }
    
    var body: some View {
        Section(section.sectionTitle()) {
            ForEach(viewModel.getItems(for: section), id: \.persistentModelID) { item in
                ZStack {
                    NavigationLink("", value: item)
                    if let logoListable = viewModel.getLogoListableItem(for: section, item: item) {
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
                showSheet(section: section)
            }
        }
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.last else {
            return
        }
        
        viewModel.deleteSelected(in: section, index: index)
    }
    
    func showSheet(section: HomeSection) {
        coordinator.leagueSelectable = section == .leagues
        coordinator.isSheetPresented = true
    }
}
