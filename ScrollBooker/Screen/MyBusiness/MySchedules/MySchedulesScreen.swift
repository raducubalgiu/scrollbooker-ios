//
//  MySchedulesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct MySchedulesScreen: View {
    let viewModel: MySchedulesViewModel
    var onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.viewState {
            case .idle, .loading:
                LoadingView()
                
            case .error:
                ErrorView(message: String(localized: "somethingWentWrong")) {
                    Task { await viewModel.loadSchedules() }
                }
                
            case .success(let schedules):
                if !schedules.isEmpty {
                    MySchedulesSuccessView(
                        viewModel: viewModel,
                        schedules: schedules,
                        onBack: onBack
                    )
                } else {
                    NoDataView(
                        title: String(localized: "schedule"),
                        message: String(localized: "noScheduleFound"),
                        systemImage: "calendar.badge.exclamationmark"
                    )
                }
            }
        }
        .task {
            await viewModel.loadSchedules()
        }
    }
}
