//
//  Season.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import Foundation

enum SeasonDate {
    case start
    case end
}

struct Season: Decodable, Hashable {
    let year: Int?
    let startDate: String?
    let endDate: String?
    let current: Bool?
    let coverage: Coverage?
    
    enum CodingKeys: String, CodingKey {
        case year
        case startDate = "start"
        case endDate = "end"
        case current
        case coverage
    }
    
    func seasonDate(point: SeasonDate) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateValue(point: point))
    }
    
    private func dateValue(point: SeasonDate) -> String {
        switch point {
        case .start:
            return self.startDate ?? ""
        case .end:
            return self.endDate ?? ""
        }
    }
}
