//
//  MyCalendarViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class MyCalendarViewModel {
    private(set) var calendarHeaderState: FeatureState<CalendarHeaderData> = .idle
    private(set) var calendarEventsState: FeatureState<CalendarEvents> = .idle
    private(set) var daySchedule: Schedule?

    private(set) var slotDurationMinutes: Int = 60
    private(set) var appointmentGapMinutes: Int = 0
    private(set) var isSavingCalendarSettings = false

    private(set) var isBlocking = false
    private(set) var defaultBlockedStartLocale: Set<String> = []
    private(set) var selectedStartLocale: Set<String> = []
    private(set) var isSavingBlock = false

    var selectedDay: Date = Date()

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "MyCalendar")

    private let userId: Int
    private let businessId: Int
    private let employeeId: Int?
    private let isOwner: Bool
    private let hasEmployees: Bool

    private let getUserAvailableDaysUseCase: GetUserAvailableDaysUseCase
    private let getUserCalendarEventsUseCase: GetUserCalendarEventsUseCase
    private let getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase
    private let getUserCalendarSettingsUseCase: GetUserCalendarSettingsUseCase
    private let updateSlotDurationUseCase: UpdateSlotDurationUseCase
    private let updateAppointmentGapUseCase: UpdateAppointmentGapUseCase
    private let createBlockAppointmentsUseCase: CreateBlockAppointmentsUseCase
    private let toastCenter: ToastCenter

    private static let isoDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let englishWeekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    init(
        userId: Int,
        businessId: Int,
        businessOwnerId: Int?,
        hasEmployees: Bool,
        getUserAvailableDaysUseCase: GetUserAvailableDaysUseCase,
        getUserCalendarEventsUseCase: GetUserCalendarEventsUseCase,
        getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase,
        getUserCalendarSettingsUseCase: GetUserCalendarSettingsUseCase,
        updateSlotDurationUseCase: UpdateSlotDurationUseCase,
        updateAppointmentGapUseCase: UpdateAppointmentGapUseCase,
        createBlockAppointmentsUseCase: CreateBlockAppointmentsUseCase,
        toastCenter: ToastCenter
    ) {
        self.userId = userId
        self.businessId = businessId
        self.hasEmployees = hasEmployees
        self.getUserAvailableDaysUseCase = getUserAvailableDaysUseCase
        self.getUserCalendarEventsUseCase = getUserCalendarEventsUseCase
        self.getSchedulesByUserIdUseCase = getSchedulesByUserIdUseCase
        self.getUserCalendarSettingsUseCase = getUserCalendarSettingsUseCase
        self.updateSlotDurationUseCase = updateSlotDurationUseCase
        self.updateAppointmentGapUseCase = updateAppointmentGapUseCase
        self.createBlockAppointmentsUseCase = createBlockAppointmentsUseCase
        self.toastCenter = toastCenter
        self.isOwner = businessOwnerId == userId

        if let businessOwnerId, businessOwnerId != userId {
            self.employeeId = userId
        } else {
            self.employeeId = nil
        }
    }

    private var targetUserId: Int {
        employeeId ?? userId
    }

    var canSetAppointmentGap: Bool {
        !(isOwner && hasEmployees)
    }

    var hasFreeSlots: Bool {
        (calendarEventsState.data?.days.first?.slots ?? []).contains { $0.isFreeSlot }
    }

    var hasPendingBlockChanges: Bool {
        selectedStartLocale != defaultBlockedStartLocale
    }

    var pendingBlockSlots: Set<String> {
        selectedStartLocale.subtracting(defaultBlockedStartLocale)
    }

    func loadInitialData() async {
        await loadCalendarSettings()
        await loadCalendarHeader()
    }

    func loadCalendarSettings() async {
        do {
            let settings = try await getUserCalendarSettingsUseCase(userId: userId)
            slotDurationMinutes = settings.slotDurationMinutes
            appointmentGapMinutes = settings.appointmentGapMinutes
        } catch {
            logger.error("ERROR: on fetching user calendar settings: \(error.localizedDescription, privacy: .public)")
        }
    }

    func saveSlotDuration(_ minutes: Int) async {
        isSavingCalendarSettings = true

        do {
            let settings = try await updateSlotDurationUseCase(minutes: minutes)
            slotDurationMinutes = settings.slotDurationMinutes
            isSavingCalendarSettings = false
            calendarHeaderState = .idle
            await loadCalendarHeader()
        } catch {
            isSavingCalendarSettings = false
            toastCenter.show(logger.userMessage(for: error, context: "Updating Slot Duration"), type: .error)
        }
    }

    func saveAppointmentGap(_ minutes: Int) async {
        isSavingCalendarSettings = true

        do {
            let settings = try await updateAppointmentGapUseCase(minutes: minutes)
            appointmentGapMinutes = settings.appointmentGapMinutes
            isSavingCalendarSettings = false
        } catch {
            isSavingCalendarSettings = false
            toastCenter.show(logger.userMessage(for: error, context: "Updating Appointment Gap"), type: .error)
        }
    }

    func loadCalendarHeader() async {
        guard calendarHeaderState == .idle else { return }
        calendarHeaderState = .loading

        let calendar = Calendar.current
        let today = Date()

        guard let currentMonday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            calendarHeaderState = .error("Nu s-a putut calcula începutul săptămânii.")
            return
        }

        let totalDays = 26 * 7
        var allCalendarDays: [Date] = []
        for i in 0..<totalDays {
            if let calculatedDate = calendar.date(byAdding: .day, value: i, to: currentMonday) {
                allCalendarDays.append(calculatedDate)
            }
        }

        let startDateStr = Self.isoDateFormatter.string(from: currentMonday)
        guard let endDate = calendar.date(byAdding: .day, value: totalDays - 1, to: currentMonday) else { return }
        let endDateStr = Self.isoDateFormatter.string(from: endDate)

        do {
            let daysStrings = try await withLoading {
                try await getUserAvailableDaysUseCase(
                    businessId: businessId,
                    employeeId: employeeId,
                    startDate: startDateStr,
                    endDate: endDateStr,
                    slotDuration: slotDurationMinutes
                )
            }

            let availableDaysSet = Set(daysStrings)
            calendarHeaderState = .success(CalendarHeaderData(availableDays: availableDaysSet, allCalendarDays: allCalendarDays))

            await loadDayEvents(for: selectedDay)
        } catch {
            calendarHeaderState = .error(logger.userMessage(for: error, context: "Loading My Calendar Header"))
        }
    }

    func loadDayEvents(for date: Date) async {
        selectedDay = date

        let dayStr = Self.isoDateFormatter.string(from: date)

        calendarEventsState = .loading

        async let scheduleTask: [Schedule]? = try? getSchedulesByUserIdUseCase(userId: targetUserId)

        do {
            let events = try await withLoading {
                try await getUserCalendarEventsUseCase(
                    businessId: businessId,
                    employeeId: employeeId,
                    startDate: dayStr,
                    endDate: dayStr,
                    slotDuration: slotDurationMinutes
                )
            }

            calendarEventsState = .success(events)
            syncBlockedSelection(events: events)

            let weekdayName = Self.englishWeekdayFormatter.string(from: date)
            daySchedule = (await scheduleTask)?.first { $0.dayOfWeek == weekdayName }
        } catch {
            calendarEventsState = .error(logger.userMessage(for: error, context: "Loading My Calendar Day Events"))
        }
    }

    func onDaySelected(date: Date) async {
        if isBlocking {
            resetSelectedLocalDates()
        }
        await loadDayEvents(for: date)
    }

    private func syncBlockedSelection(events: CalendarEvents) {
        let blocked = Set(
            (events.days.first?.slots ?? [])
                .filter { $0.isBlocked }
                .map(\.startDateLocale)
        )
        defaultBlockedStartLocale = blocked
        selectedStartLocale = blocked
    }

    func toggleBlocking() {
        isBlocking.toggle()
    }

    func setBlockDate(_ startDateLocale: String) {
        if selectedStartLocale.contains(startDateLocale) {
            selectedStartLocale.remove(startDateLocale)
        } else {
            selectedStartLocale.insert(startDateLocale)
        }
    }

    func resetSelectedLocalDates() {
        selectedStartLocale = defaultBlockedStartLocale
        isBlocking = false
    }

    func blockAppointments(message: String) async {
        isSavingBlock = true

        guard let slots = calendarEventsState.data?.days.first?.slots else {
            isSavingBlock = false
            return
        }

        let slotsToBlock = slots
            .filter { pendingBlockSlots.contains($0.startDateLocale) }
            .map {
                AppointmentBlockSlotDTO(startDate: $0.startDateUtc, endDate: $0.endDateUtc, userId: targetUserId)
            }

        guard !slotsToBlock.isEmpty else {
            isSavingBlock = false
            return
        }

        do {
            try await createBlockAppointmentsUseCase(
                request: AppointmentBlockRequestDTO(blockedMessage: message, slots: slotsToBlock)
            )
            isSavingBlock = false
            await loadDayEvents(for: selectedDay)
            resetSelectedLocalDates()
        } catch {
            isSavingBlock = false
            toastCenter.show(logger.userMessage(for: error, context: "Blocking Appointments"), type: .error)
        }
    }
}
