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
            Text("Nothing to display!")
        case .error(let errorMsg):
            VStack {
                Text(errorMsg)
                    .foregroundColor(.red)
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
