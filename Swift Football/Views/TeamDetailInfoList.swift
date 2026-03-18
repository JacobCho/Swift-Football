//
//  TeamDetailInfoList.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-17.
//

import Foundation
import SwiftUI

struct TeamDetailInfoList: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .foregroundStyle(backgroundColor())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    func backgroundColor() -> Color {
        if colorScheme == .light {
            return Color(red: 0.91, green: 0.91, blue: 0.91)
        } else {
            return Color(red: 0.22, green: 0.22, blue: 0.22)
        }
    }
    
}
