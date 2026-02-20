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
class CountriesViewModel: SwiftDataViewModel {
    @Published var countries: [Country] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private let countriesFetcher = CountriesFetcher()
    
    func dataExists() -> Bool {
        let descriptor = FetchDescriptor<Country>()
        do {
            let count = try modelContext.fetchCount(descriptor)
            print("$$ count \(count)")
            return count > 0
        } catch {
            return false
        }
    }
    
    func fetchCountries(name: String? = nil, code: String? = nil, search: String? = nil) async {
        if isLoading || countries.count > 0 { return }
        isLoading = true
        errorMessage = nil
        
        if dataExists() {
            do {
                countries = try modelContext.fetch(FetchDescriptor<Country>(sortBy: [SortDescriptor(\.id, order: .forward)]))
            } catch {
                errorMessage = error.localizedDescription
            }
        } else {
            do {
                let response: CountriesResponse = try await countriesFetcher.fetchCountries(name: name, code: code, search: search)
                countries = response.countries.map { Country(dto: $0) }
                saveData(countries)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
        isLoading = false
    }
}
