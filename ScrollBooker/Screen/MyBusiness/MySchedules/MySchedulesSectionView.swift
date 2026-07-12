//
//  MySchedulesSectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import SwiftUI

struct MySchedulesSectionView: View {
    let viewModel: MySchedulesViewModel
    var onBack: () -> Void
    
    @State private var showErrors = false
    
    private var isFormValid: Bool {
        viewModel.uiState.data.allSatisfy { isScheduleValid(start: $0.startTime, end: $0.endTime) }
    }
    
    private var invalidScheduleIds: Set<Int> {
        Set(viewModel.uiState.data.filter { !isScheduleValid(start: $0.startTime, end: $0.endTime) }.map { $0.id })
    }
    
    var body: some View {
        FormLayout(
            headline: String(localized: "schedule"),
            subHeadline: String(localized: "scheduleSubheaderDescription"),
            enableBottomButton: true,
            enableBack: true,
            buttonTitle: String(localized: "save"),
            isDisabled: viewModel.isSaving,
            isLoading: viewModel.isSaving,
            onBack: onBack,
            onClick: {
                if isFormValid {
                    showErrors = false
                    Task { await viewModel.saveSchedules() }
                } else {
                    withAnimation { showErrors = true }
                }
            }
        ) {
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(viewModel.uiState.data) { schedule in
                        ScheduleRow(
                            schedule: schedule,
                            onChange: { start, end in
                                let cleanStart = start == "null" ? nil : start
                                let cleanEnd = end == "null" ? nil : end
                                
                                let updated = Schedule(
                                    id: schedule.id,
                                    dayOfWeek: schedule.dayOfWeek,
                                    startTime: cleanStart,
                                    endTime: cleanEnd
                                )
                                
                                viewModel.updateLocalScheduleRow(updatedSchedule: updated)
                            },
                            isNotValid: invalidScheduleIds.contains(schedule.id),
                            showErrors: showErrors
                        )
                    }
                }
                .padding(.top, 12)
            }
        }
    }
    
    private func isScheduleValid(start: String?, end: String?) -> Bool {
        guard let start = start, let end = end, start != "null", end != "null" else { return true }
        return start < end
    }
}

