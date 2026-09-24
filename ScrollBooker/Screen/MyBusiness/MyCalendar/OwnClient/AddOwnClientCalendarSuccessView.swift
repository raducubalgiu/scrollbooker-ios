//
//  AddOwnClientCalendarSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct AddOwnClientCalendarSuccessView: View {
    let availableDays: Set<String>
    let allCalendarDays: [Date]
    let viewModel: AddOwnClientViewModel
    var onSlotConfirmed: () -> Void

    @State private var currentWeekPage: Int = 0
    @State private var currentDayPage: Int = 0

    @State private var isUpdatingFromWeek: Bool = false
    @State private var isUpdatingFromDay: Bool = false

    private var nextAvailableDate: Date? {
        let calendar = Calendar.current
        let startOfSelectedDay = calendar.startOfDay(for: viewModel.selectedDay)

        return allCalendarDays
            .filter { calendar.startOfDay(for: $0) > startOfSelectedDay && availableDays.contains($0.asISODateString()) }
            .min()
    }

    private func navigateToDay(_ date: Date) {
        guard let targetIndex = allCalendarDays.firstIndex(where: { Calendar.current.isDate($0, inSameDayAs: date) }) else { return }
        isUpdatingFromDay = true
        withAnimation(.easeInOut(duration: 0.3)) {
            currentDayPage = targetIndex
        }
    }

    var body: some View {
        let currentWeekIndex = currentWeekPage
        let firstDayOfWeek = allCalendarDays[safe: currentWeekIndex * 7] ?? Date()
        let periodLabel = firstDayOfWeek.formatted(.dateTime.month(.wide).year())

        let enableBack = currentWeekPage > 0
        let enableNext = currentWeekPage < 25

        VStack(spacing: 0) {
            CalendarActionsView(
                period: periodLabel,
                enableBack: enableBack,
                enableNext: enableNext,
                handlePreviousWeek: {
                    isUpdatingFromWeek = true
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentWeekPage -= 1
                    }
                },
                handleNextWeek: {
                    isUpdatingFromWeek = true
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentWeekPage += 1
                    }
                }
            )
            .padding(.top, 8)

            Spacer().frame(height: 12)

            CalendarHeaderPagerView(
                currentWeekPage: $currentWeekPage,
                calendarDays: allCalendarDays,
                availableDaysSet: availableDays,
                selectedDay: viewModel.selectedDay,
                onChangeTab: { targetDayIndex -> Void in
                    isUpdatingFromDay = true
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentDayPage = targetDayIndex
                    }
                }
            )

            Spacer().frame(height: 16)

            AddOwnClientCalendarContentPagerView(
                currentDayPage: $currentDayPage,
                slotsState: viewModel.availableSlotsState,
                viewModel: viewModel,
                onNextOpenDayTap: nextAvailableDate.map { date in { navigateToDay(date) } },
                onSlotSelected: { slot in
                    viewModel.selectSlot(slot)
                    onSlotConfirmed()
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: currentDayPage) { _, newDayIndex in
            guard !isUpdatingFromWeek else {
                isUpdatingFromWeek = false
                return
            }

            let targetWeekPage = newDayIndex / 7
            if currentWeekPage != targetWeekPage {
                isUpdatingFromDay = true
                currentWeekPage = targetWeekPage
            }

            if let targetDate = allCalendarDays[safe: newDayIndex] {
                Task {
                    await viewModel.onDaySelected(date: targetDate)
                }
            }
        }
        .onChange(of: currentWeekPage) { _, newWeekIndex in
            guard !isUpdatingFromDay else {
                isUpdatingFromDay = false
                return
            }

            let currentDayOfWeekComponent = Calendar.current.component(.weekday, from: viewModel.selectedDay)
            let dayOffset = (currentDayOfWeekComponent + 5) % 7

            let targetDayIndex = (newWeekIndex * 7) + dayOffset

            if currentDayPage != targetDayIndex {
                isUpdatingFromWeek = true
                currentDayPage = targetDayIndex
            }

            if let targetDate = allCalendarDays[safe: targetDayIndex] {
                Task {
                    await viewModel.onDaySelected(date: targetDate)
                }
            }
        }
    }
}
