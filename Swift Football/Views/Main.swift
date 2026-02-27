//
//  Swift_FootballApp.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import SwiftUI
import SwiftData
import SDWebImage
import SDWebImageSVGCoder

@main
struct Main: App {
    @StateObject var coordinator: Coordinator
    var container: ModelContainer
    
    init() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
        do {
            container = try ModelContainer(for: Schema([Country.self, League.self]), configurations: [])
            let coordinator = Coordinator(modelContext: container.mainContext)
            _coordinator = StateObject(wrappedValue: coordinator)
            
        } catch {
            fatalError("Failed to create ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                Button {
                    coordinator.isSheetPresented = true
                } label: {
                    Text("Show Sheet")
                }
            }
            .sheet(isPresented: $coordinator.isSheetPresented) {
                NavigationStack {
                    coordinator.view(for: .countries)
                }
            }
            .environmentObject(coordinator)
            .modelContainer(container)
        }
    }
}

