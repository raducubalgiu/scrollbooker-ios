//
//  MySchedulesSectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import SwiftUI

struct MySchedulesSuccessView: View {
    let schedules: [Schedule]
    let isSaving: Bool
    let onBack: () -> Void
    let onScheduleChanged: (Schedule) -> Void
    let onSave: () -> Void

    @State private var showErrors = false

    private var isFormValid: Bool {
        schedules.allSatisfy(\.isValid)
    }

    private var invalidScheduleIds: Set<Int> {
        Set(schedules.filter { !$0.isValid }.map { $0.id })
    }

    var body: some View {
        FormLayout(
            headline: String(localized: "my_business_schedule"),
            subHeadline: String(localized: "my_business_schedule_full_description"),
            enableBottomButton: true,
            enableBack: true,
            buttonTitle: String(localized: "save"),
            isDisabled: isSaving,
            isLoading: isSaving,
            onBack: onBack,
            onClick: {
                if isFormValid {
                    showErrors = false
                    onSave()
                } else {
                    withAnimation { showErrors = true }
                }
            }
        ) {
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(schedules) { schedule in
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

                                onScheduleChanged(updated)
                            },
                            isNotValid: invalidScheduleIds.contains(schedule.id),
                            showErrors: showErrors
                        )
                    }
                }
                .padding(.top, 12)
                .padding(.horizontal, .xl)
            }
        }
    }
}
