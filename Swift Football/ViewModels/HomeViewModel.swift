//
//  HomeViewModel.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-02.
//

import Foundation
import SwiftData

enum HomeSection {
    case leagues
    case teams
    
    func sectionTitle() -> String {
        switch self {
        case .leagues:
            return "Favourite Leagues"
        case .teams:
            return "Favourite Teams"
        }
    }
}

@Observable
class HomeViewModel: BaseViewModel {
    var sections: [HomeSection] = [.leagues, .teams]
    private let dataProvider: SwiftDataProvider
    
    init(dataProvider: SwiftDataProvider) {
        self.dataProvider = dataProvider
    }

    func getLogoListableItem(for section: HomeSection, item: any PersistentModel) -> LogoListable? {
        switch section {
        case .leagues:
            if let league = item as? League {
                return league
            }
        case .teams:
            if let teamInfo = item as? TeamInfo {
                return teamInfo.team
            }
        }
        return nil
    }
}
