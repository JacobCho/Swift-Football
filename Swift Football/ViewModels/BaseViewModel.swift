//
//  SwiftDataExtensions.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-19.
//

import SwiftData
internal import Combine
import Foundation

enum LoadState: Equatable {
    case loading
    case empty
    case error(String)
    case finished
}

@Observable
class BaseViewModel {
    var loadState: LoadState = .empty
    
    func loadingFinished(isEmpty: Bool) {
        // Don't override an error state
        if case .error = loadState {
            return
        }
        if isEmpty {
            loadState = .empty
            return
        }
        // Only transition to finished if we were loading
        if case .loading = loadState {
            loadState = .finished
        }
    }
}

