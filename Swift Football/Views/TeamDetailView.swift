//
//  TeamDetailView.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-03-11.
//

import Foundation
import SwiftUI

struct TeamDetailView: View {
    @State private var viewModel: TeamsViewModel
    let teamDTO: TeamDTO
    
    init(team: TeamDTO, dataProvider: SwiftDataProvider) {
        self.teamDTO = team
        let viewModel = TeamsViewModel(dataProvider: dataProvider)
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
                Spacer()
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
