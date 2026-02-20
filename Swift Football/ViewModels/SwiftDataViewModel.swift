//
//  SwiftDataExtensions.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-19.
//

import SwiftData
internal import Combine

@MainActor
class SwiftDataViewModel: ObservableObject {
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func saveData(_ objects: [any PersistentModel]) {
        try? modelContext.transaction {
            for object in objects {
                modelContext.insert(object)
            }
            try? modelContext.save()
        }
    }
}
