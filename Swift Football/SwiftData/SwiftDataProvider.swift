//
//  SwiftDataProvider.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-27.
//

import Foundation
import SwiftData

@ModelActor
actor SwiftDataProvider {
    func fetch<T: PersistentModel>(for type: T.Type,
                                   predicate: Predicate<T>? = nil,
                                   sortBy: [SortDescriptor<T>]? = nil) -> [T] {
        var sort: [SortDescriptor<T>] = [SortDescriptor(\.id, order: .forward)]
        if let sortBy {
            sort.append(contentsOf: sortBy)
        }
        let descriptor: FetchDescriptor<T>
        if let predicate {
            descriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sort)
        } else {
            descriptor = FetchDescriptor<T>(sortBy: sort)
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
    
    func save() {
        try? modelContext.save()
    }
}
