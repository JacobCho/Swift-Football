//
//  HomeViewModel.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-02.
//

import Foundation
internal import Combine
import SwiftData

class HomeViewModel: BaseViewModel {
    var leagues: [League] = []
    private let dataProvider: SwiftDataProvider
    
    init(dataProvider: SwiftDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchSelectedLeagues() async {
        if loadState == .loading || loadState == .finished { return }
        loadState = .loading
        
        let predicate = #Predicate<League> { league in
            league.isSelected
        }
        
        let savedLeagues = await dataProvider.fetch(for: League.self, predicate: predicate)
        
        if savedLeagues.count > 0 {
            leagues = savedLeagues
        }
        loadingFinished(isEmpty: leagues.count == 0)
    }
}
