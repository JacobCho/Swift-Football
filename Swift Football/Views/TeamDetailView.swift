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
    case statistics
    
    func buttonTitle() -> String {
        switch self {
        case .overview:
            return "Overview"
        case .players:
            return "Players"
        case .statistics:
            return "Statistics"
        }
    }
}

struct TeamDetailView: View {
    @State private var viewModel: TeamsViewModel
    @State private var detailInfoViews = [TeamDetailInfo.overview, TeamDetailInfo.players, TeamDetailInfo.statistics]
    let teamDTO: TeamDTO
    @State private var selectedSeason: Int
    @State private var scrollPosition: ScrollPosition = ScrollPosition(idType: TeamDetailInfo.RawValue.self, edge: .leading)
    
    init(team: TeamDTO, season: Int, dataProvider: SwiftDataProvider) {
        self.teamDTO = team
        _selectedSeason = State(initialValue: season)
        let viewModel = TeamsViewModel(dataProvider: dataProvider, selectedSeason: season)
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
                            ForEach(detailInfoViews, id: \.self) { view in
                                Rectangle()
                                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                                    .foregroundStyle(.red)
                                    .id(view.rawValue)
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
        .task {
            fetch()
        }
    }
    
    func fetch() {
        Task {
            await viewModel.fetchTeamForDetail(id: teamDTO.id)
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
                result.image?
                    .resizable()
                    .scaledToFit()
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
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(detailInfoViews, id: \.self) { view in
                    Button {
                        withAnimation {
                            scrollPosition.scrollTo(id: view.rawValue)
                        }
                    } label: {
                        Text(view.buttonTitle())
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                            .font(.system(size: 16, weight: .semibold))
                    }
                        .containerRelativeFrame(.horizontal, count: 3, spacing: 10)
                }
            }
        }
    }
}
