//
//  Swift_FootballApp.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import SwiftUI
import SDWebImage
import SDWebImageSVGCoder

@main
struct Main: App {
    @StateObject var coordinator = Coordinator()
    
    init() {
            SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
        }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.view(for: .countries)
            }
            .environmentObject(coordinator)
        }
    }
}

#Preview {
    CountriesListView()
}
