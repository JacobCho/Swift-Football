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
    case leagues(country: Country)
    case standings(league: League)
    
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
        }
    }
}

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var isSheetPresented = false
    private var modelContext: ModelContext
    private var swiftDataProvider: SwiftDataProvider
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.swiftDataProvider = SwiftDataProvider(modelContext: modelContext)
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
        case .leagues(let country):
            LeaguesListView(country: country, dataProvider: swiftDataProvider)
        case .standings(let league):
            StandingsListView(league: league)
        }
    }
}
