//
//  CountriesViewModel.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-27.
//

import Foundation
internal import Combine
import SwiftData

@MainActor
class CountriesViewModel: BaseViewModel {
    @Published var countries: [Country] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private let countriesFetcher = CountriesFetcher()
    private let dataProvider: SwiftDataProvider
    
    init(dataProvider: SwiftDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchCountries(name: String? = nil, code: String? = nil, search: String? = nil) async {
        if isLoading || countries.count > 0 { return }
        isLoading = true
        errorMessage = nil
        
        let savedCountries = await dataProvider.fetch(for: Country.self)
        
        if savedCountries.count > 0 {
            countries = savedCountries
        } else {
            do {
                let response: CountriesResponse = try await countriesFetcher.fetchCountries(name: name, code: code, search: search)
                countries = response.countries.map { Country(dto: $0) }
                await dataProvider.saveData(countries)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
        isLoading = false
    }
}
