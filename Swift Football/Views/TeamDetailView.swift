//
//  TeamDetailView.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-11.
//

import Foundation
import SwiftUI

struct TeamDetailView: View {
    @State private var viewModel: TeamsViewModel
    let teamDTO: TeamDTO
    
    init(team: TeamDTO, dataProvider: SwiftDataProvider) {
        self.teamDTO = team
        let viewModel = TeamsViewModel(dataProvider: dataProvider)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        
    }
}
