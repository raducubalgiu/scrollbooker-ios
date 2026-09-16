//
//  MyBusinessSchedulesTab.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import SwiftUI

struct MyBusinessSchedulesTab: View {
    let viewModel: MyBusinessDetailsViewModel

    @State private var showErrors = false

    private var isFormValid: Bool {
        (viewModel.schedulesState.data ?? []).allSatisfy(\.isValid)
    }

    private var invalidScheduleIds: Set<Int> {
        Set((viewModel.schedulesState.data ?? []).filter { !$0.isValid }.map { $0.id })
    }

    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.schedulesState {
            case .idle, .loading:
                LoadingView()

            case .error:
                ErrorView(message: String(localized: "message_error_something_went_wrong")) {
                    Task { await viewModel.loadBusinessDetails() }
                }

            case .success(let schedules):
                ScrollView {
                    VStack(spacing: AppSize.xl.rawValue) {
                        ForEach(schedules) { schedule in
                            ScheduleRow(
                                schedule: schedule,
                                onChange: { start, end in
                                    let cleanStart = start == "null" ? nil : start
                                    let cleanEnd = end == "null" ? nil : end

                                    viewModel.updateLocalScheduleRow(
                                        Schedule(
                                            id: schedule.id,
                                            dayOfWeek: schedule.dayOfWeek,
                                            startTime: cleanStart,
                                            endTime: cleanEnd
                                        )
                                    )
                                },
                                isNotValid: invalidScheduleIds.contains(schedule.id),
                                showErrors: showErrors
                            )
                        }
                    }
                    .padding(.base)
                }

                MainButton(
                    title: String(localized: "save"),
                    isDisabled: viewModel.isSavingSchedules,
                    isLoading: viewModel.isSavingSchedules,
                    onClick: {
                        if isFormValid {
                            showErrors = false
                            Task { await viewModel.saveSchedules() }
                        } else {
                            withAnimation { showErrors = true }
                        }
                    }
                )
                .padding(.base)
            }
        }
    }
}
