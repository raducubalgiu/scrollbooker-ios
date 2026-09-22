//
//  MyCalendarContentView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct MyCalendarContentView: View {
    let headerData: CalendarHeaderData
    let selectedDay: Date
    let calendarEventsState: FeatureState<CalendarEvents>
    let daySchedule: Schedule?
    let slotDuration: Int
    let isBlocking: Bool
    let hasFreeSlots: Bool
    let pendingBlockSlots: Set<String>
    let showsEmployeeDropdown: Bool
    let ownAvatarURL: URL?
    let ownFullName: String
    let selectedEmployee: Employee?
    @Binding var currentWeekPage: Int
    var onOpenEmployeeSheet: () -> Void
    var onToggleBlocking: () -> Void
    var onDaySelected: (Date) -> Void
    var onSlotTap: (CalendarEventsSlot) -> Void
    var onRetry: () -> Void

    var body: some View {
        let allCalendarDays = headerData.allCalendarDays
        let enableBack = currentWeekPage > 0
        let enableNext = currentWeekPage < MyCalendarViewModel.totalWeeks - 1

        VStack(spacing: 0) {
            MyCalendarHeaderActionsView(
                showsEmployeeDropdown: showsEmployeeDropdown,
                ownAvatarURL: ownAvatarURL,
                ownFullName: ownFullName,
                selectedEmployee: selectedEmployee,
                isBlocking: isBlocking,
                hasFreeSlots: hasFreeSlots,
                enableBack: enableBack,
                enableNext: enableNext,
                onOpenEmployeeSheet: onOpenEmployeeSheet,
                onToggleBlocking: onToggleBlocking,
                onPreviousWeek: { withAnimation(.easeInOut(duration: 0.3)) { currentWeekPage -= 1 } },
                onNextWeek: { withAnimation(.easeInOut(duration: 0.3)) { currentWeekPage += 1 } }
            )

            Spacer().frame(height: 12)

            CalendarHeaderPagerView(
                currentWeekPage: $currentWeekPage,
                calendarDays: allCalendarDays,
                availableDaysSet: headerData.availableDays,
                selectedDay: selectedDay,
                totalWeeks: MyCalendarViewModel.totalWeeks,
                alwaysTappable: true,
                onChangeTab: { targetDayIndex in
                    guard let targetDate = allCalendarDays[safe: targetDayIndex] else { return }
                    onDaySelected(targetDate)
                }
            )

            Spacer().frame(height: 16)

            MyCalendarContentPagerView(
                calendarEventsState: calendarEventsState,
                daySchedule: daySchedule,
                slotDuration: slotDuration,
                isBlocking: isBlocking,
                pendingBlockSlots: pendingBlockSlots,
                onSlotTap: onSlotTap,
                onRetry: onRetry
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: currentWeekPage) { _, newWeekIndex in
            let currentDayOfWeekComponent = Calendar.current.component(.weekday, from: selectedDay)
            let dayOffset = (currentDayOfWeekComponent + 5) % 7
            let targetDayIndex = (newWeekIndex * 7) + dayOffset

            if let targetDate = allCalendarDays[safe: targetDayIndex] {
                onDaySelected(targetDate)
            }
        }
    }
}
