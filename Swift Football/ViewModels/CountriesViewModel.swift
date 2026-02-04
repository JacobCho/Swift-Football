//
//  CountriesViewModel.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-27.
//

import Foundation
internal import Combine

@MainActor
class CountriesViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private let countriesFetcher = CountriesFetcher()
    
    func fetchCountries(name: String? = nil, code: String? = nil, search: String? = nil) async {
        if isLoading { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let response: CountriesResponse = try await countriesFetcher.fetchCountries(name: name, code: code, search: search)
            await MainActor.run {
                countries = response.countries
            }
        } catch {
            errorMessage = error.errorMessage
        }
        isLoading = false
    }
}
