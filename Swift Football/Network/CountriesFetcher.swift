//
//  CountriesFetcher.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import Foundation

class CountriesFetcher: DataFetcher {
    
    /// Parameters:
    /// name: Name of the country
    /// code: Code of the country; 2 - 6 chars
    /// search: Name of the country; >= 3 chars
    
    func fetchCountries(name: String? = nil, code: String? = nil, search: String? = nil) async throws -> CountriesResponse {
        var parameters: [String: String] = [:]
        
        if let name {
            parameters["name"] = name
        }
        if let code, code.count >= 2 && code.count <= 6 {
            parameters["code"] = code
        }
        if let search, search.count >= 3 {
            parameters["search"] = search
        }
        
        do {
            let response: CountriesResponse = try await self.fetch(endPoint: .countries, parameters: parameters)
            return response
        }  catch {
            throw error
        }
    }
}
