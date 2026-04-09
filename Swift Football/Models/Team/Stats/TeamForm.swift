//
//  TeamForm.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-31.
//

import Foundation
import SwiftUI

enum MatchResult: String {
    case win = "W"
    case draw = "D"
    case loss = "L"
}

struct TeamForm: Identifiable {
    let id = UUID()
    let gameWeek: Int
    let result: MatchResult
    
    var color: Color {
        switch result {
        case .win:
            return .win
        case .draw:
            return .draw
        case .loss:
            return .lose
        }
    }
}
