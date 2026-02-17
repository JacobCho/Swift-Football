//
//  CloseButton.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-02-17.
//

import SwiftUI

struct CloseButton: View {
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        Button {
            coordinator.dismissSheet()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
                .frame(width: 30, height: 30)
                .clipShape(Circle())
        }
    }
}
