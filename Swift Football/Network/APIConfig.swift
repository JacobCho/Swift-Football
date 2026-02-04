//
//  APIConfig.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-27.
//

import Foundation

enum APIConfig {
    static var apiKey: String {
        return Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    }
}
