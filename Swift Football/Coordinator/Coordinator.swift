//
//  NavigationViewModel.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-02.
//

import SwiftUI
internal import Combine

enum Route: Hashable {
    case countries
    case leagues(country: Country)
    case standings(details: LeagueDetails)
}

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func pop() {
        path.removeLast()
    }
    
    func push(destination: Route) {
        path.append(destination)
    }
    
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .countries:
            CountriesListView()
        case .leagues(let country):
            LeaguesListView(country: country)
        case .standings(let details):
            StandingsListView(leagueDetails: details)
        }
    }
}
