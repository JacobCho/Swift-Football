//
//  UnderOverStatsContainer.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-24.
//

import Foundation

struct UnderOverStatsContainer: Decodable {
    let lessThanOne: UnderOverStat?
    let onePointFive: UnderOverStat?
    let twoPointFive: UnderOverStat?
    let threePointFive: UnderOverStat?
    let fourPointFive: UnderOverStat?
    
    enum CodingKeys: String, CodingKey {
        case lessThanOne = "0.5"
        case onePointFive = "1.5"
        case twoPointFive = "2.5"
        case threePointFive = "3.5"
        case fourPointFive = "4.5"
    }
}
