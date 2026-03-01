//
//  BaseView.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-27.
//

import Foundation
import SwiftUI

struct LoadStateView: View {
    var loadState: LoadState
    var buttonAction: (() -> Void)
    
    var body: some View {
        switch loadState {
        case .loading:
            ProgressView()
        case .empty:
            EmptyStateView()
        case .error(let errorMsg):
            ContentUnavailableView {
                Label("Connection Failed", systemImage: "network.slash")
            } description: {
                Text(errorMsg)
            } actions: {
                Button("Retry") {
                    buttonAction()
                }
            }
        case .finished:
            // Leave for other view
            EmptyView()
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        ContentUnavailableView("No content to display", systemImage: "doc.richtext.fill")
    }
}
