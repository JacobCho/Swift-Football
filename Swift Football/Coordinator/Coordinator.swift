//
//  NavigationViewModel.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-02.
//

import SwiftUI
internal import Combine

enum Route: Identifiable, Hashable {
    case countries
    case leagues(country: Country)
    case standings(details: LeagueDetails)
    
    var id: String {
        switch self {
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
        case .countries:
            CountriesListView()
        case .leagues(let country):
            LeaguesListView(country: country)
        case .standings(let details):
            StandingsListView(leagueDetails: details)
        }
    }
}
