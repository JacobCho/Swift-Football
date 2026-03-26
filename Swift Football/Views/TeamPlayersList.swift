//
//  TeamPlayersList.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-26.
//

import Foundation
import SwiftUI

struct TeamPlayersList: View {
    let viewModel: TeamsViewModel
    let listRowBackgroundColor: Color
    
    var body: some View {
        ForEach(viewModel.getPlayerPositions(), id: \.rawValue) { position in
            DisclosureGroup(position.rawValue) {
                ForEach(viewModel.getPlayers(for: position), id: \.player.id) { playerInfo in
                    TeamInfoPlayersCell(playerInfo: playerInfo)
                        .frame(maxHeight: 30)
                }
            }
            .disclosureGroupStyle(GroupStyle())
            .listRowBackground(listRowBackgroundColor)
        }
    }
}
