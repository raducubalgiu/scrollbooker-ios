//
//  MySchedulesSectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import SwiftUI

struct MySchedulesSectionView: View {
    @Binding var schedules: [Schedule]
    let isSaving: Bool
    let onUpdateRow: (Schedule) -> Void
    let onHandleSave: () -> Void
    let onBack: () -> Void
    
    @State private var showErrors = false
    
    private var isFormValid: Bool {
        schedules.allSatisfy { isScheduleValid(start: $0.startTime, end: $0.endTime) }
    }
    
//    private var invalidScheduleIds: Set<String> {
//        Set(schedules.filter { !isScheduleValid(start: $0.startTime, end: $0.endTime) }.map { $0.id })
//    }
    
    var body: some View {
        // Folosim exact parametrii pe care îi are FormLayout-ul tău din proiect
        FormLayout(
            headline: String(localized: "schedule"),
            subHeadline: String(localized: "scheduleSubheaderDescription"),
            enableBack: true,
            buttonTitle: String(localized: "save")
        ) {
            // Conținutul principal (Trailing Closure)
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(schedules) { schedule in
                        ScheduleRow(
                            schedule: schedule,
                            onChange: { start, end in
//                                var updated = schedule
//                                updated.startTime = start == "null" ? nil : start
//                                updated.endTime = end == "null" ? nil : end
//                                onUpdateRow(updated)
                            },
                            isNotValid: false,
                            showErrors: showErrors
                        )
                    }
                }
            }
        }
    }
    
    private func isScheduleValid(start: String?, end: String?) -> Bool {
        guard let start = start, let end = end, start != "null", end != "null" else { return true }
        return start < end
    }
}

