//
//  TeamDetailView.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-11.
//

import Foundation
import SwiftUI

enum TeamDetailInfo: Int {
    case overview
    case players
    case teamStats
    case playerStats
    
    func buttonTitle() -> String {
        switch self {
        case .overview:
            return "Overview"
        case .players:
            return "Players"
        case .teamStats:
            return "Team Stats"
        case .playerStats:
            return "Player Stats"
        }
    }
    
    func sections() -> [TeamDetailInfoSections] {
        switch self {
        case .overview:
            return [.leagues, .captain, .venue]
        case .players:
            return [.players]
        case .teamStats:
            return [.teamRecord, .teamForm]
        case .playerStats:
            return [.playerStats]
        }
    }
}

enum TeamDetailInfoSections: Int {
    case leagues
    case captain
    case venue
    case players
    case teamRecord
    case teamForm
    case playerStats
    
    func sectionTitle() -> String {
        switch self {
        case .leagues:
            return "Leagues"
        case .captain:
            return "Captain"
        case .venue:
            return "Venue"
        case .players:
            return "Players"
        case .teamRecord:
            return "Team Record"
        case .teamForm:
            return "Team Form"
        case .playerStats:
            return "Player Statistics"
        }
    }
}

struct TeamDetailView: View {
    @State private var viewModel: TeamsViewModel
    @State private var detailInfoViews = [TeamDetailInfo.overview, TeamDetailInfo.players, TeamDetailInfo.teamStats, TeamDetailInfo.playerStats]
    let teamId: Int
    @State private var selectedSeason: Int
    @State private var scrollPosition: ScrollPosition = ScrollPosition(idType: TeamDetailInfo.RawValue.self, edge: .leading)
    
    init(teamId: Int, season: Int, dataProvider: SwiftDataProvider) {
        self.teamId = teamId
        _selectedSeason = State(initialValue: season)
        let viewModel = TeamsViewModel(dataProvider: dataProvider, selectedSeason: season, teamId: teamId)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if viewModel.loadState != .finished {
                LoadStateView(loadState: viewModel.loadState, buttonAction: fetch)
            } else if let teamInfo = viewModel.teamInfo {
                TeamHeaderView(logo: teamInfo.team.logo ?? "", teamName: viewModel.teamName(), subTitle: viewModel.subtitle())
                    .frame(maxWidth: .infinity, maxHeight: 70, alignment: .top)
                    .padding(.top, 8)
                VStack {
                    TeamInfoButtonScrollView(detailInfoViews: detailInfoViews, scrollPosition: $scrollPosition)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(detailInfoViews, id: \.self) { infoView in
                                TeamDetailInfoList(detailInfo: infoView, viewModel: viewModel)
                                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                                    .id(infoView.rawValue)
                            }
                        }
                    }
                    .scrollTargetLayout()
                    .scrollTargetBehavior(.viewAligned)
                    .scrollDisabled(true)
                    .scrollPosition($scrollPosition)
                    .contentMargins(10, for: .scrollContent)
                    .scrollIndicators(.hidden)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.top, 16)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                FavouriteButton(viewModel: viewModel)
            }
        }
        .task {
            fetch()
        }
    }
    
    func fetch() {
        Task {
            await viewModel.fetchTeamForDetail()
            await viewModel.fetchInvolvedLeagues()
            await viewModel.fetchPlayerStats()
            await viewModel.fetchTeamStats()
        }
    }
}

struct FavouriteButton: View {
    let viewModel: TeamsViewModel
    
    var body: some View {
        Button {
            viewModel.saveTeamAsFavourite()
        } label: {
            
            Image(systemName: viewModel.isTeamFavourited() ? "star.fill" : "star")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
                .frame(width: 30, height: 30)
                .clipShape(Circle())
        }
    }
}

struct TeamHeaderView: View {
    let logo: String
    let teamName: String
    let subTitle: String
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: logo)) { result in
                if let image = result.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if let _ = result.error {
                    Image(systemName: "person.3.fill")
                }
            }
            .frame(maxWidth: 70, maxHeight: 70, alignment: .leading)
            .padding(.leading, 8)
            .padding(.trailing, 5)
            VStack {
                Text(teamName)
                    .font(.system(size: 25, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(subTitle)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct TeamInfoButtonScrollView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let detailInfoViews: [TeamDetailInfo]
    @Binding var scrollPosition: ScrollPosition
    @State var currentSelected: Int = 0
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(detailInfoViews, id: \.self) { view in
                    Button {
                        currentSelected = view.rawValue
                        withAnimation {
                            scrollPosition.scrollTo(id: view.rawValue)
                        }
                    } label: {
                        Text(view.buttonTitle())
                            .foregroundStyle(buttonColor(viewId: view.rawValue))
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .containerRelativeFrame(.horizontal, count: 4, spacing: 10, alignment: .center)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    func buttonColor(viewId: Int) -> Color {
        let isSelected = currentSelected == viewId
        if colorScheme == .light {
            return isSelected ? .black : .gray
        } else {
            return isSelected ? .white : .gray
        }
    }
}
