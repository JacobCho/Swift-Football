//
//  CountriesResponse.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-10.
//

import Foundation

struct CountriesResponse: Decodable {
    var countries: [CountryDTO]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.countries = try container.decode([CountryDTO].self, forKey: .countries)
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
