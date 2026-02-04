//
//  CountriesListView.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-27.
//

import SwiftUI

struct CountriesListView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var viewModel = CountriesViewModel()
    @State private var searchText = ""
    
    var filtered: [Country] {
        if searchText.isEmpty {
            return viewModel.countries
        } else {
            return viewModel.countries.filter {
                if let name = $0.name {
                    return name.localizedCaseInsensitiveContains(searchText)
                }
                return false
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                VStack {
                    Text(error)
                        .foregroundColor(.red)
                    Button("Retry") {
                        Task {
                            await viewModel.fetchCountries()
                        }
                    }
                }
            } else {
                List(filtered) { country in
                    ZStack {
                        NavigationLink("", value: country)
                        
                        LogoListRow(listable: country)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .listRowSpacing(-20)
                .navigationBarTitle("Countries")
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 10)
                }
                .searchable(text: $searchText, prompt: "Search countries")
                .navigationDestination(for: Country.self) { country in
                    coordinator.view(for: .leagues(country: country))
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchCountries()
            }
        }
    }
}

