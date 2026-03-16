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
    @State private var viewModel: CountriesViewModel
    @State private var searchText = ""
    @Query(sort: [SortDescriptor(\Country.name, order: .forward)]) private var countries: [Country]
    
    init(dataProvider: SwiftDataProvider) {
        let viewModel = CountriesViewModel(dataProvider: dataProvider)
        _viewModel = State(initialValue: viewModel)
    }
    
    var filtered: [Country] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter {
                if let name = $0.name {
                    return name.localizedCaseInsensitiveContains(searchText)
                }
                return false
            }
        }
    }
    
    var body: some View {
        VStack {
            if viewModel.loadState != .finished {
                LoadStateView(loadState: viewModel.loadState, buttonAction: fetch)
            } else {
                if countries.count == 0 {
                    EmptyStateView()
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
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            CloseButton()
                                .environmentObject(coordinator)
                        }
                    }
                    .navigationDestination(for: Country.self) { country in
                        if let code = country.code {
                            coordinator.view(for: .leagues(countryCode: code))
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search countries")
        .task {
            fetch()
        }
        .navigationBarTitle("Countries")
    }
    
    func fetch() {
        Task {
            await viewModel.fetchCountries()
        }
    }
}

