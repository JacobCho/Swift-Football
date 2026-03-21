//
//  TeamInfoPlayersList.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-19.
//

import Foundation
import SwiftUI

struct TeamInfoPlayersCell: View {
    let playerInfo: PlayerInfoContainer
    var showAge = true
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: playerInfo.player.photo ?? "")) { result in
                if let image = result.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if let _ = result.error {
                    Image(systemName: "person.fill")
                }
            }
                .frame(minWidth: 20, minHeight: 30, alignment: .leading)
                .padding(.leading, 0)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(playerInfo.player.name ?? "")
                    .font(.system(size: 14))
                Text(playerInfo.player.nationality ?? "")
                    .font(.system(size: 10))
            }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 5)
            if let age = playerInfo.player.age, showAge {
                Text((String(age)))
                    .frame(minWidth: 20, maxWidth: 20, alignment: .trailing)
                    .padding()
            }
        }
            .cornerRadius(10)
            .listRowSeparator(.hidden)
            .font(.system(size: 12))
            .lineLimit(1)
    }
}
