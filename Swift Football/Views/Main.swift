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
                Button {
                    coordinator.isSheetPresented = true
                } label: {
                    Text("Show Sheet")
                }
                //coordinator.view(for: .countries)
            }
            .sheet(isPresented: $coordinator.isSheetPresented) {
                NavigationStack {
                    coordinator.view(for: .countries)
                }
            }
//            .sheet(item: $coordinator.presentedSheet) { destination in
//                coordinator.view(for: destination)
//            }
            .environmentObject(coordinator)
        }
    }
}

