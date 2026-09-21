//
//  MyCalendarScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct MyCalendarScreen: View {
    @State var viewModel: MyCalendarViewModel
    var onBack: () -> Void

    @State private var currentWeekPage: Int = 0
    @State private var showSettings = false
    @State private var showBlockSheet = false

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: String(localized: "myCalendar"),
                onBack: onBack,
                customAction: {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))
                            .foregroundColor(.onBackgroundSB)
                    }
                }
            )

            switch viewModel.calendarHeaderState {
                case .idle, .loading:
                    LoadingView()

                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.loadCalendarHeader() }
                    }

                case .success(let headerData):
                    calendarContent(headerData: headerData)
            }

            if viewModel.isBlocking {
                MyCalendarBlockActionBarView(
                    isEnabled: viewModel.hasPendingBlockChanges,
                    onCancel: { viewModel.resetSelectedLocalDates() },
                    onBlockConfirm: { showBlockSheet = true }
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundSB)
        .task {
            await viewModel.loadInitialData()
        }
        .fullScreenCover(isPresented: $showSettings) {
            MyCalendarSettingsScreen(viewModel: viewModel, onBack: { showSettings = false })
        }
        .sheet(isPresented: $showBlockSheet) {
            MyCalendarBlockSheetView(
                dayLabel: viewModel.selectedDay.formatted(.dateTime.weekday(.wide).day().month(.wide)),
                selectedSlots: viewModel.pendingBlockSlots,
                onConfirmBlock: { message in
                    await viewModel.blockAppointments(message: message)
                }
            )
            .presentationDetents([.fraction(0.75), .large])
        }
    }

    @ViewBuilder
    private func calendarContent(headerData: CalendarHeaderData) -> some View {
        let allCalendarDays = headerData.allCalendarDays
        let firstDayOfWeek = allCalendarDays[safe: currentWeekPage * 7] ?? Date()
        let periodLabel = firstDayOfWeek.formatted(.dateTime.month(.wide).year())
        let enableBack = currentWeekPage > 0
        let enableNext = currentWeekPage < 25

        VStack(spacing: 0) {
            CalendarActionsView(
                period: periodLabel,
                enableBack: enableBack,
                enableNext: enableNext,
                handlePreviousWeek: { withAnimation(.easeInOut(duration: 0.3)) { currentWeekPage -= 1 } },
                handleNextWeek: { withAnimation(.easeInOut(duration: 0.3)) { currentWeekPage += 1 } }
            )
            .padding(.top, 8)

            HStack {
                Spacer()

                MyCalendarBlockToggleButton(
                    isActive: viewModel.isBlocking,
                    isEnabled: viewModel.hasFreeSlots,
                    onTap: { viewModel.toggleBlocking() }
                )
            }
            .padding(.horizontal, .base)
            .padding(.top, 8)

            Spacer().frame(height: 12)

            CalendarHeaderPagerView(
                currentWeekPage: $currentWeekPage,
                calendarDays: allCalendarDays,
                availableDaysSet: headerData.availableDays,
                selectedDay: viewModel.selectedDay,
                onChangeTab: { targetDayIndex in
                    guard let targetDate = allCalendarDays[safe: targetDayIndex] else { return }
                    Task { await viewModel.onDaySelected(date: targetDate) }
                }
            )

            Spacer().frame(height: 16)

            MyCalendarContentPagerView(
                calendarEventsState: viewModel.calendarEventsState,
                daySchedule: viewModel.daySchedule,
                slotDuration: viewModel.slotDurationMinutes,
                isBlocking: viewModel.isBlocking,
                pendingBlockSlots: viewModel.pendingBlockSlots,
                onSlotTap: { slot in
                    if viewModel.isBlocking && slot.isFreeSlot {
                        viewModel.setBlockDate(slot.startDateLocale)
                    }
                },
                onRetry: { Task { await viewModel.loadDayEvents(for: viewModel.selectedDay) } }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: currentWeekPage) { _, newWeekIndex in
            let currentDayOfWeekComponent = Calendar.current.component(.weekday, from: viewModel.selectedDay)
            let dayOffset = (currentDayOfWeekComponent + 5) % 7
            let targetDayIndex = (newWeekIndex * 7) + dayOffset

            if let targetDate = allCalendarDays[safe: targetDayIndex] {
                Task { await viewModel.onDaySelected(date: targetDate) }
            }
        }
    }
}
