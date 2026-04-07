//
//  FormChart.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-04-07.
//

import Foundation
import SwiftUI
import Charts

struct FormChart: View {
    let data: [TeamForm]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Chart(data) { form in
                RectangleMark(x: .value("Game Week", form.gameWeek),
                              y: .value("Points", 1), width: .fixed(28.0), height: .fixed(55.0))
                .foregroundStyle(form.color.opacity(0.85))
                .annotation(position: .bottom) {
                    Text(form.result.rawValue)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .chartYAxis(.hidden)
            .chartXScale(domain: .automatic(reversed: true))
            .chartXAxis(content: {
                let rangeStart = 1
                let rangeEnd = data.count
                AxisMarks(preset: .aligned, values: stride(from: rangeStart, through: rangeEnd, by: 1).map { $0 }) { value in
                    let intValue = value.as(Int.self) ?? 0
                    
                    // Add marks for first, last, and every value divisible by 5
                    if intValue == rangeStart || intValue == rangeEnd || intValue % 5 == 0 {
                        AxisGridLine(centered: true)
                            .offset(x: 22, y: 0)
                        AxisValueLabel()
                            .offset(x: 22, y: 0)
                    }
                }
            })
            .chartPlotStyle(content: { plot in
                let width: CGFloat = 28.0
                let height: CGFloat = 55
                plot.frame(width: width * CGFloat(data.count), height: height)
                    .padding(.horizontal, 8)
            })
            .padding(.horizontal, 8)
        }
    }
}
