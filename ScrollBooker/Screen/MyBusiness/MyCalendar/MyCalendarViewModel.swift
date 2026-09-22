//
//  MyCalendarViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation
import Observation
import OSLog
import SwiftUI

@Observable
@MainActor
final class MyCalendarViewModel {
    static let pastWeeksCount = 26
    static let futureWeeksCount = 26
    static var totalWeeks: Int { pastWeeksCount + futureWeeksCount }

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

    private(set) var employeesState: FeatureState<[Employee]> = .idle
    private(set) var selectedEmployeeId: Int?
    private(set) var employeesAvailability: [Int: Bool] = [:]

    private(set) var selectedOwnClientSlot: CalendarEventsSlot?

    var selectedDay: Date = Date()

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "MyCalendar")

    private let userId: Int
    private let businessId: Int
    private let selfEmployeeId: Int?
    private let isOwner: Bool
    private let hasEmployeesFlag: Bool
    let ownAvatar: String?
    let ownFullName: String

    private let getUserAvailableDaysUseCase: GetUserAvailableDaysUseCase
    private let getUserCalendarEventsUseCase: GetUserCalendarEventsUseCase
    private let getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase
    private let getUserCalendarSettingsUseCase: GetUserCalendarSettingsUseCase
    private let updateSlotDurationUseCase: UpdateSlotDurationUseCase
    private let updateAppointmentGapUseCase: UpdateAppointmentGapUseCase
    private let createBlockAppointmentsUseCase: CreateBlockAppointmentsUseCase
    private let getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase
    private let getEmployeesAvailabilityForDayUseCase: GetEmployeesAvailabilityForDayUseCase
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
        ownAvatar: String?,
        ownFullName: String,
        getUserAvailableDaysUseCase: GetUserAvailableDaysUseCase,
        getUserCalendarEventsUseCase: GetUserCalendarEventsUseCase,
        getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase,
        getUserCalendarSettingsUseCase: GetUserCalendarSettingsUseCase,
        updateSlotDurationUseCase: UpdateSlotDurationUseCase,
        updateAppointmentGapUseCase: UpdateAppointmentGapUseCase,
        createBlockAppointmentsUseCase: CreateBlockAppointmentsUseCase,
        getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase,
        getEmployeesAvailabilityForDayUseCase: GetEmployeesAvailabilityForDayUseCase,
        toastCenter: ToastCenter
    ) {
        self.userId = userId
        self.businessId = businessId
        self.hasEmployeesFlag = hasEmployees
        self.ownAvatar = ownAvatar
        self.ownFullName = ownFullName
        self.getUserAvailableDaysUseCase = getUserAvailableDaysUseCase
        self.getUserCalendarEventsUseCase = getUserCalendarEventsUseCase
        self.getSchedulesByUserIdUseCase = getSchedulesByUserIdUseCase
        self.getUserCalendarSettingsUseCase = getUserCalendarSettingsUseCase
        self.updateSlotDurationUseCase = updateSlotDurationUseCase
        self.updateAppointmentGapUseCase = updateAppointmentGapUseCase
        self.createBlockAppointmentsUseCase = createBlockAppointmentsUseCase
        self.getEmployeesByOwnerUseCase = getEmployeesByOwnerUseCase
        self.getEmployeesAvailabilityForDayUseCase = getEmployeesAvailabilityForDayUseCase
        self.toastCenter = toastCenter
        self.isOwner = businessOwnerId == userId

        if let businessOwnerId, businessOwnerId != userId {
            self.selfEmployeeId = userId
        } else {
            self.selfEmployeeId = nil
        }
    }

    var effectiveEmployeeId: Int? {
        if let selfEmployeeId { return selfEmployeeId }
        if isOwner && hasEmployeesFlag { return selectedEmployeeId }
        return nil
    }

    var targetUserId: Int {
        effectiveEmployeeId ?? userId
    }

    var resolvedBusinessId: Int {
        businessId
    }

    var showsEmployeeDropdown: Bool {
        isOwner && hasEmployeesFlag
    }

    var selectedEmployee: Employee? {
        employeesState.data?.first { $0.id == selectedEmployeeId }
    }

    var canSetAppointmentGap: Bool {
        !(isOwner && hasEmployeesFlag)
    }

    var hasFreeSlots: Bool {
        (calendarEventsState.data?.days.first?.slots ?? []).contains { $0.isFreeSlot }
    }

    var domainColor: Color {
        guard let shortDomain = calendarEventsState.data?.businessShortDomain else { return .primarySB }
        return BusinessShortDomainEnum(fromKeyOrUnknown: shortDomain).domainColor
    }

    var hasPendingBlockChanges: Bool {
        selectedStartLocale != defaultBlockedStartLocale
    }

    var pendingBlockSlots: Set<String> {
        selectedStartLocale.subtracting(defaultBlockedStartLocale)
    }

    func loadInitialData() async {
        await loadCalendarSettings()
        if showsEmployeeDropdown {
            await loadEmployees()
        }
        await loadCalendarHeader()
    }

    func loadEmployees() async {
        employeesState = .loading

        do {
            let employees = try await getEmployeesByOwnerUseCase(businessOwnerId: userId)
            employeesState = .success(employees)
            if selectedEmployeeId == nil {
                selectedEmployeeId = employees.first?.id
            }
        } catch {
            employeesState = .error(logger.userMessage(for: error, context: "Loading Employees"))
        }
    }

    func loadEmployeesAvailability() async {
        do {
            let list = try await getEmployeesAvailabilityForDayUseCase(
                day: Self.isoDateFormatter.string(from: selectedDay),
                slotDuration: slotDurationMinutes
            )
            employeesAvailability = Dictionary(uniqueKeysWithValues: list.map { ($0.employeeId, $0.hasAvailability) })
        } catch {
            logger.error("ERROR: on fetching employees availability: \(error.localizedDescription, privacy: .public)")
        }
    }

    func selectEmployee(_ employeeId: Int) async {
        guard selectedEmployeeId != employeeId else { return }
        selectedEmployeeId = employeeId
        calendarHeaderState = .idle
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
        guard !showsEmployeeDropdown || selectedEmployeeId != nil else { return }
        calendarHeaderState = .loading

        let calendar = Calendar.current
        let today = Date()

        guard let currentMonday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)),
              let windowStart = calendar.date(byAdding: .weekOfYear, value: -Self.pastWeeksCount, to: currentMonday) else {
            calendarHeaderState = .error("Nu s-a putut calcula începutul săptămânii.")
            return
        }

        let totalDays = Self.totalWeeks * 7
        var allCalendarDays: [Date] = []
        for i in 0..<totalDays {
            if let calculatedDate = calendar.date(byAdding: .day, value: i, to: windowStart) {
                allCalendarDays.append(calculatedDate)
            }
        }

        let startDateStr = Self.isoDateFormatter.string(from: windowStart)
        guard let endDate = calendar.date(byAdding: .day, value: totalDays - 1, to: windowStart) else { return }
        let endDateStr = Self.isoDateFormatter.string(from: endDate)

        do {
            let daysStrings = try await withLoading {
                try await getUserAvailableDaysUseCase(
                    businessId: businessId,
                    employeeId: effectiveEmployeeId,
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
                    employeeId: effectiveEmployeeId,
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

    func setSelectedOwnClient(_ slot: CalendarEventsSlot?) {
        selectedOwnClientSlot = slot
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
