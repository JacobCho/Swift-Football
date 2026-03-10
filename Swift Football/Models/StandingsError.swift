//
//  StandingsError.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-09.
//

import Foundation

struct StandingsErrorResponse: Decodable {
    var plan: String?
    
    enum CodingKeys: String, CodingKey {
        case plan
    }
}

enum StandingsError: DescriptiveError {
    case missingParameters
    case planError(String)
    
    var description: String {
        switch self {
        case .missingParameters:
            return "Missing Parameters in standings call"
        case .planError(let error):
            return error
        }
        
    }
}
