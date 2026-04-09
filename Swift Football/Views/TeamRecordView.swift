//
//  TeamStatsList.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-26.
//

import Foundation
import SwiftUI

struct TeamRecordView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let stats: TeamStats
    var body: some View {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
            GridRow {
                RecordStatView(playedStat: stats.fixtures?.winsStat, goalsStat: nil, title: "Wins", customStatColor: Color(.win))
                RecordStatView(playedStat: stats.fixtures?.drawsStat, goalsStat: nil, title: "Draws", customStatColor: Color(.draw))
                RecordStatView(playedStat: stats.fixtures?.losesStat, goalsStat: nil, title: "Loses", customStatColor: Color(.lose))
            }
            Divider()
            GridRow {
                RecordStatView(playedStat: nil, goalsStat: stats.goals?.goalsFor, title: "Goals For", customStatColor: nil)
                RecordStatView(playedStat: nil, goalsStat: stats.goals?.goalsAgainst, title: "Goals Against", customStatColor: nil)
                RecordStatView(playedStat: stats.cleanSheet, goalsStat: nil, title: "Clean sheets", customStatColor: nil)
            }
        }
    }
    
    func defaultColor() -> Color {
        return colorScheme == .light ? .black : .white
    }
    
}

struct RecordStatView: View {
    let playedStat: TeamPlayedStat?
    let goalsStat: DetailedGoalsStat?
    let title: String
    let customStatColor: Color?
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
            if let playedStat, let total = playedStat.total, let home = playedStat.home, let away = playedStat.away  {
                Text(total)
                    .foregroundStyle(customStatColor ?? .primary)
                    .font(.system(size: 22, weight: .semibold))
                    .padding(1)
                Text("\(home)H · \(away)A ")
                    .font(.system(size: 13))
            }
            if let goalsStat, let total = goalsStat.total?.total, let average = goalsStat.average?.total {
                Text(total)
                    .font(.system(size: 22, weight: .semibold))
                    .padding(1)
                Text("\(average) avg")
                    .font(.system(size: 13))
            }
        }
    }
}
