//
//  NavigationViewModel.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-02.
//

import SwiftUI
import SwiftData
internal import Combine

enum Route: Identifiable, Hashable {
    case home
    case countries
    case leagues(countryCode: String)
    case standings(league: League)
    case teamDetail(id: Int, selectedSeason: Int)
    
    var id: String {
        switch self {
        case .home:
            return "home"
        case .countries:
            return "countries"
        case .leagues(_):
            return "leagues"
        case .standings(_):
            return "details"
        case .teamDetail:
            return "team"
        }
    }
}

@Observable
class Coordinator {
    var path = NavigationPath()
    var isSheetPresented = false
    private var modelContext: ModelContext
    private var swiftDataProvider: SwiftDataProvider
    var leagueSelectable = true
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.swiftDataProvider = SwiftDataProvider(modelContainer: modelContext.container)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func push(destination: Route) {
        path.append(destination)
    }
    
    func presentSheet() {
        isSheetPresented = true
    }
    
    func dismissSheet() {
        isSheetPresented = false
    }
    
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .home:
            HomeView(dataProvider: swiftDataProvider)
        case .countries:
            CountriesListView(dataProvider: swiftDataProvider)
        case .leagues(let countryCode):
            LeaguesListView(countryCode: countryCode, dataProvider: swiftDataProvider)
        case .standings(let league):
            StandingsListView(league: league)
        case .teamDetail(let id, let season):
            TeamDetailView(teamId: id, season: season, dataProvider: swiftDataProvider)
        }
    }
}
