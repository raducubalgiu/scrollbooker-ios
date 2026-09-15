//
//  CollectBusinessSchedulesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct CollectBusinessSchedulesScreen: View {
    let viewModel: CollectBusinessSchedulesViewModel
    let onBack: () -> Void

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
                        schedules: schedules,
                        isSaving: viewModel.isSaving,
                        onBack: onBack,
                        onScheduleChanged: { viewModel.updateLocalScheduleRow(updatedSchedule: $0) },
                        onSave: { Task { await viewModel.collectBusinessSchedules() } }
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
