//
//  TeamInfoVenueView.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-19.
//

import Foundation
import SwiftUI

struct TeamInfoVenueView: View {
    let viewModel: TeamsViewModel
    
    var body: some View {
        VStack {
            if let image = viewModel.teamInfo?.venue.image {
                AsyncImage(url: URL(string: image)) { result in
                    if let image = result.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else if let _ = result.error {
                        Image(systemName: "house.and.flag.fill")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            if let stadiumName = viewModel.teamInfo?.venue.name {
                Text(stadiumName)
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.top, 8)
            }
            
            if let teamInfo = viewModel.teamInfo, let city = teamInfo.venue.city, let country = teamInfo.team.country {
                Text("\(city), \(country)")
            }
            if let capacity = viewModel.teamInfo?.venue.capacity {
                Text("Capacity: \(capacity)")
            }
        }
    }
}
