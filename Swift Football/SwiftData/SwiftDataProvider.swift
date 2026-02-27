//
//  SwiftDataProvider.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-27.
//

import Foundation
import SwiftData

actor SwiftDataProvider {
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetch<T: PersistentModel>(for type: T.Type,
                                   predicate: Predicate<T>? = nil,
                                   sortBy: [SortDescriptor<T>] = [SortDescriptor(\.id, order: .forward)]) -> [T] {
        let descriptor: FetchDescriptor<T>
        if let predicate {
            descriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortBy)
        } else {
            descriptor = FetchDescriptor<T>(sortBy: sortBy)
        }
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            return []
        }
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
