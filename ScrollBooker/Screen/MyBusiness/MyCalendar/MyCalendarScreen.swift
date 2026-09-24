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
    var makeAddOwnClientViewModel: (CalendarEventsSlot?) -> AddOwnClientViewModel

    @State private var currentWeekPage: Int = MyCalendarViewModel.pastWeeksCount
    @State private var showSettings = false
    @State private var showBlockSheet = false
    @State private var showEmployeeSheet = false
    @State private var addOwnClientViewModel: AddOwnClientViewModel?

    private var showAddOwnClient: Binding<Bool> {
        Binding(
            get: { addOwnClientViewModel != nil },
            set: { isPresented in if !isPresented { addOwnClientViewModel = nil } }
        )
    }

    private var isFabVisible: Bool {
        viewModel.calendarEventsState.data != nil && !viewModel.isBlocking
    }

    private var periodLabel: String {
        let allCalendarDays = viewModel.calendarHeaderState.data?.allCalendarDays ?? []
        let firstDayOfWeek = allCalendarDays[safe: currentWeekPage * 7] ?? Date()
        return firstDayOfWeek.formatted(.dateTime.month(.wide).year())
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                HeaderView(
                    customTitle: {
                        AnyView(
                            VStack(spacing: 2) {
                                Text(String(localized: "calendar"))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Text(periodLabel)
                                    .font(.headline.bold())
                                    .foregroundColor(.onBackgroundSB)
                            }
                        )
                    },
                    onBack: onBack,
                    customAction: {
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.system(size: 22.5))
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
                        MyCalendarContentView(
                            headerData: headerData,
                            selectedDay: viewModel.selectedDay,
                            calendarEventsState: viewModel.calendarEventsState,
                            daySchedule: viewModel.daySchedule,
                            slotDuration: viewModel.slotDurationMinutes,
                            isBlocking: viewModel.isBlocking,
                            hasFreeSlots: viewModel.hasFreeSlots,
                            pendingBlockSlots: viewModel.pendingBlockSlots,
                            showsEmployeeDropdown: viewModel.showsEmployeeDropdown,
                            ownAvatarURL: viewModel.ownAvatar.flatMap(URL.init(string:)),
                            ownFullName: viewModel.ownFullName,
                            selectedEmployee: viewModel.selectedEmployee,
                            currentWeekPage: $currentWeekPage,
                            onOpenEmployeeSheet: {
                                showEmployeeSheet = true
                                Task { await viewModel.loadEmployeesAvailability() }
                            },
                            onToggleBlocking: { viewModel.toggleBlocking() },
                            onDaySelected: { date in Task { await viewModel.onDaySelected(date: date) } },
                            onSlotTap: { slot in
                                if viewModel.isBlocking && slot.isFreeSlot {
                                    viewModel.setBlockDate(slot.startDateLocale)
                                } else if !viewModel.isBlocking && slot.isFreeSlot {
                                    viewModel.setSelectedOwnClient(slot)
                                    addOwnClientViewModel = makeAddOwnClientViewModel(slot)
                                }
                            },
                            onRetry: { Task { await viewModel.loadDayEvents(for: viewModel.selectedDay) } }
                        )
                }

                if viewModel.isBlocking {
                    MyCalendarBlockActionBarView(
                        isEnabled: viewModel.hasPendingBlockChanges,
                        onCancel: { viewModel.resetSelectedLocalDates() },
                        onBlockConfirm: { showBlockSheet = true }
                    )
                }
            }

            if isFabVisible {
                MyCalendarFabView(
                    isEnabled: viewModel.hasFreeSlots,
                    domainColor: viewModel.domainColor,
                    onTap: {
                        viewModel.setSelectedOwnClient(nil)
                        addOwnClientViewModel = makeAddOwnClientViewModel(nil)
                    }
                )
                .padding(.base)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isFabVisible)
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
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(25)
        }
        .sheet(isPresented: $showEmployeeSheet) {
            MyCalendarEmployeeSheetView(
                employeesState: viewModel.employeesState,
                selectedEmployeeId: viewModel.selectedEmployeeId,
                employeesAvailability: viewModel.employeesAvailability,
                onSelect: { employeeId in
                    showEmployeeSheet = false
                    Task { await viewModel.selectEmployee(employeeId) }
                },
                onClose: { showEmployeeSheet = false }
            )
            .presentationDetents([.fraction(0.6), .large])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(25)
        }
        .fullScreenCover(isPresented: showAddOwnClient) {
            if let addOwnClientViewModel {
                AddOwnClientScreen(
                    viewModel: addOwnClientViewModel,
                    onBack: { self.addOwnClientViewModel = nil },
                    onSaved: {
                        self.addOwnClientViewModel = nil
                        Task { await viewModel.loadDayEvents(for: viewModel.selectedDay) }
                    }
                )
            }
        }
    }
}
