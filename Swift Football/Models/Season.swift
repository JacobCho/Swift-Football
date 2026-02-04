//
//  Season.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import Foundation

struct Season: Decodable {
    let year: Int?
    let startDate: String?
    let endDate: String?
    let current: Bool?
    let coverage: Coverage?
}
