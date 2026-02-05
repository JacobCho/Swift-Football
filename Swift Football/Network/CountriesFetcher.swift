//
//  CountriesFetcher.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import Foundation
internal import Combine

struct CountriesResponse: Decodable {
    var countries: [Country]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.countries = try container.decode([Country].self, forKey: .countries)
        self.countries = self.countries.enumerated().map { (index, element) in
            var country = element
            country.id = index
            return country
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case countries = "response"
    }
}

class CountriesFetcher: DataFetcher {
    
    /// Parameters:
    /// name: Name of the country
    /// code: Code of the country; 2 - 6 chars
    /// search: Name of the country; >= 3 chars
    
    func fetchCountries(name: String? = nil, code: String? = nil, search: String? = nil) async throws(NetworkError) -> CountriesResponse {
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
            let response: CountriesResponse = try await self.fetch(endPoint: "countries", parameters: parameters)
            cachedResponse = response
            return response
        }  catch {
            throw .decodingError(error)
        }
    }
}
