//
//  StandingsListView.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-30.
//

import SwiftUI

struct StandingsListView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var viewModel = StandingsViewModel()
    let league: League
    
    var body: some View {
        HStack {
            Spacer()
            PickerMenu(viewModel: $viewModel, onChange: fetch)
        }
        .frame(maxWidth: .infinity, maxHeight: 35, alignment: .top)
        if viewModel.loadState != .finished {
            Spacer()
        }
        VStack {
            if viewModel.loadState != .finished {
                LoadStateView(loadState: viewModel.loadState, buttonAction: fetch)
            } else {
                VStack(spacing: -20) {
                    List {
                        ForEach(Array(viewModel.standings.enumerated()), id: \.offset) { _, standings in
                            Section {
                                ForEach(standings) { standing in
                                    ZStack {
                                        NavigationLink("", value: standing.team)
                                        StandingTeamCell(viewModel: viewModel, standing: standing)
                                    }
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                }
                            } header: {
                                StandingsHeader(groupName: standings.first?.group ?? "",
                                                shouldDisplayGroupName: viewModel.standings.count > 1)
                            }
                        }
                        
                        Section {
                            ForEach(viewModel.standingsDescriptionsLegend()) { legend in
                                StandingDescriptionLegendCell(legend: legend)
                            }
                        }
                    }
                    .font(.system(size: 11))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .listRowSpacing(-25)
                    .listStyle(.insetGrouped)
                    .navigationBarTitleDisplayMode(.inline)
                    .safeAreaInset(edge: .top) {
                        Color.clear.frame(height: 10)
                    }
                    .navigationDestination(for: TeamDTO.self) { team in
                        coordinator.view(for: .teamDetail(team: team))
                    }
                }
            }
        }
        .navigationBarTitle(viewModel.navTitle())
        .onAppear {
            Task {
                await viewModel.fetchSeasons()
                await viewModel.fetchStandings(league: league.id)
            }
        }
    }
    
    func fetch() {
        Task {
            await viewModel.fetchStandings(league: league.id)
        }
    }
}

struct StandingsHeader: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var groupName: String
    var shouldDisplayGroupName: Bool = false
    
    var body: some View {
        HStack {
            Text(shouldDisplayGroupName ? groupName : "Team")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, shouldDisplayGroupName ? 0 : 45)
            HStack {
                StandingsText(text: "PL")
                StandingsText(text: "W")
                StandingsText(text: "D")
                StandingsText(text: "L")
                StandingsText(text: "GD")
                StandingsText(text: "PTS")
            }
            .multilineTextAlignment(.center)
            .frame(alignment: .trailing)
            .padding(.trailing, 8)
        }
        .foregroundStyle(colorScheme == .light ? .black : .white)
        .font(.system(size: 11, weight: .semibold))
    }
}

struct PickerMenu: View {
    @Binding var viewModel: StandingsViewModel
    var onChange: (() -> Void)
    
    var body: some View {
        Menu {
            Picker(viewModel.selectedSeason, selection: $viewModel.selectedSeason) {
                ForEach(viewModel.seasons.enumerated(), id: \.element) { index, season in
                    Text(season).tag(season)
                }
            }
            .pickerStyle(.menu)
        } label: {
            Label("Current Season: \(viewModel.selectedSeason)", systemImage: "chevron.down")
                .frame(maxHeight: 35)
                .cornerRadius(8)
        }
        .compositingGroup()
        .buttonStyle(.glass)
        .onChange(of: viewModel.selectedSeason) { oldValue, newValue in
            onChange()
        }
    }
}

struct StandingsText: View {
    let text: String
    
    var body: some View {
        Text(text)
            .frame(minWidth:22, maxWidth: 22)
    }
}

struct StandingDescriptionLegendCell: View {
    var legend: StandingsDescriptionLegend
    
    var body: some View {
        HStack {
            legend.color
                .clipShape(Circle())
                .frame(width: 20, height: 20)
            Text(legend.description)
                .font(.system(size: 11))
                .lineLimit(1)
        }
        .frame(maxHeight: 30)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

struct StandingTeamCell: View {
    var viewModel: StandingsViewModel
    var standing: Standing
    
    var body: some View {
        HStack {
            viewModel.colourForDescription(standing.description)
                .frame(maxWidth: 3)
            StandingsText(text: "\(standing.rank)")
            AsyncImage(url: URL(string: standing.team?.logo ?? "")) { result in
                result.image?
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 20, height: 20)
            Text(standing.team?.name ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                StandingsText(text: viewModel.standingPlayed(standing))
                StandingsText(text: viewModel.standingWins(standing))
                StandingsText(text: viewModel.standingDraws(standing))
                StandingsText(text: viewModel.standingLosses(standing))
                StandingsText(text: viewModel.standingGD(standing))
                StandingsText(text: viewModel.standingPoints(standing))
            }
            .multilineTextAlignment(.center)
            .frame(alignment: .trailing)
            .padding(.trailing, 8)
        }
        .frame(height: 30)
        .minimumScaleFactor(0.8)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}
