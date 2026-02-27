//
//  CountriesListView.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-27.
//

import SwiftUI
import SwiftData

struct CountriesListView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var viewModel: CountriesViewModel
    @State private var searchText = ""
    
    init(dataProvider: SwiftDataProvider) {
        let viewModel = CountriesViewModel(dataProvider: dataProvider)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
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
        VStack {
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
                if filtered.count == 0 {
                    Text("Nothing to display!")
                } else {
                    List(filtered) { country in
                        ZStack {
                            NavigationLink("", value: country)
                            
                            LogoListRow(listable: country)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .frame(maxHeight: 30)
                    }
                    .listStyle(.plain)
                    .listRowSpacing(10)
                    .safeAreaInset(edge: .top) {
                        Color.clear.frame(height: 10)
                    }
                    .searchable(text: $searchText, prompt: "Search countries")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            CloseButton()
                                .environmentObject(coordinator)
                        }
                    }
                    .navigationDestination(for: Country.self) { country in
                        coordinator.view(for: .leagues(country: country))
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchCountries()
            }
        }
        .navigationBarTitle("Countries")
    }
}

