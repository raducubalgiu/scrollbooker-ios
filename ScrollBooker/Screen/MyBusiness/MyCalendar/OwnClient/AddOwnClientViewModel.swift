//
//  AddOwnClientViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import Foundation
import Observation
import OSLog

extension CalendarEventsSlot {
    func toSlot() -> Slot {
        Slot(
            startDateUtc: startDateUtc,
            endDateUtc: endDateUtc,
            startDateLocale: startDateLocale,
            endDateLocale: endDateLocale,
            isLastMinute: isLastMinute,
            lastMinuteDiscount: lastMinuteDiscount
        )
    }
}

@Observable
@MainActor
final class AddOwnClientViewModel {
    private(set) var userProductsState: FeatureState<UserProducts> = .idle
    private(set) var linkedItems: [SelectedBookingItem] = []

    private(set) var clientQuery: String = ""
    private(set) var clientsState: FeatureState<[BusinessClient]> = .idle
    private(set) var canLoadMoreClients = true
    private(set) var isLoadingMoreClients = false
    private(set) var selectedClient: BusinessClient?
    private(set) var isCreatingClient = false

    private(set) var calendarHeaderState: FeatureState<CalendarHeaderData> = .idle
    private(set) var availableSlotsState: FeatureState<[Slot]> = .idle
    var selectedDay: Date
    private(set) var selectedSlot: Slot?

    private(set) var isSaving = false

    private let businessId: Int
    private let employeeId: Int?
    private let targetUserId: Int

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "AddOwnClient")

    private let getProductsByBusinessAndEmployeeUseCase: GetProductsbyBusinessAndEmployeeUseCase
    private let getUserAvailableDaysUseCase: GetUserAvailableDaysUseCase
    private let getUserAvailableTimeslotsUseCase: GetUserAvailableTimeslotsUseCase
    private let getBusinessClientsUseCase: GetBusinessClientsUseCase
    private let createBusinessClientUseCase: CreateBusinessClientUseCase
    private let createOwnClientAppointmentUseCase: CreateOwnClientAppointmentUseCase
    private let toastCenter: ToastCenter

    private var slotsCache: [TimeslotsCacheKey: AvailableDay] = [:]
    private var searchTask: Task<Void, Never>?
    private var currentClientsPage = 1
    private static let clientsPageLimit = 20

    init(
        businessId: Int,
        employeeId: Int?,
        targetUserId: Int,
        initialDay: Date?,
        initialSlot: Slot?,
        getProductsByBusinessAndEmployeeUseCase: GetProductsbyBusinessAndEmployeeUseCase,
        getUserAvailableDaysUseCase: GetUserAvailableDaysUseCase,
        getUserAvailableTimeslotsUseCase: GetUserAvailableTimeslotsUseCase,
        getBusinessClientsUseCase: GetBusinessClientsUseCase,
        createBusinessClientUseCase: CreateBusinessClientUseCase,
        createOwnClientAppointmentUseCase: CreateOwnClientAppointmentUseCase,
        toastCenter: ToastCenter
    ) {
        self.businessId = businessId
        self.employeeId = employeeId
        self.targetUserId = targetUserId
        self.selectedDay = initialDay ?? Date()
        self.selectedSlot = initialSlot
        self.getProductsByBusinessAndEmployeeUseCase = getProductsByBusinessAndEmployeeUseCase
        self.getUserAvailableDaysUseCase = getUserAvailableDaysUseCase
        self.getUserAvailableTimeslotsUseCase = getUserAvailableTimeslotsUseCase
        self.getBusinessClientsUseCase = getBusinessClientsUseCase
        self.createBusinessClientUseCase = createBusinessClientUseCase
        self.createOwnClientAppointmentUseCase = createOwnClientAppointmentUseCase
        self.toastCenter = toastCenter
    }

    var totalDuration: Int {
        linkedItems.reduce(0) { $0 + $1.variantDuration }
    }

    var totalPriceWithDiscount: Decimal {
        linkedItems.reduce(Decimal(0)) { total, item in
            let offering = item.offerings.first(where: { $0.user.id == targetUserId }) ?? item.offerings.first
            return total + (offering?.priceWithDiscount ?? 0)
        }
    }

    var canPickDateTime: Bool {
        selectedClient != nil && !linkedItems.isEmpty
    }

    var selectedSlotDurationMinutes: Int? {
        guard let selectedSlot,
              let start = selectedSlot.startDateLocale.asLocalDateTime(),
              let end = selectedSlot.endDateLocale.asLocalDateTime() else { return nil }
        return Int(end.timeIntervalSince(start) / 60)
    }

    var hasDurationMismatch: Bool {
        guard let selectedSlotDurationMinutes, totalDuration > 0 else { return false }
        return selectedSlotDurationMinutes != totalDuration
    }

    var canSave: Bool {
        canPickDateTime && selectedSlot != nil && !isSaving && !hasDurationMismatch
    }

    func loadUserProducts() async {
        guard userProductsState.data == nil else { return }
        userProductsState = .loading

        do {
            let products = try await withLoading {
                try await getProductsByBusinessAndEmployeeUseCase(
                    businessId: businessId,
                    employeeId: targetUserId,
                    onlyServicesWithProducts: true,
                    productsLimitPerService: nil
                )
            }
            userProductsState = .success(products)
        } catch {
            userProductsState = .error(logger.userMessage(for: error, context: "Loading Products"))
        }
    }

    func setLinkedItems(_ items: [SelectedBookingItem]) {
        linkedItems = items
        resetDateTimeSelection()
    }

    func removeLinkedItem(_ item: SelectedBookingItem) {
        linkedItems.removeAll { $0.productId == item.productId }
        resetDateTimeSelection()
    }

    private func resetDateTimeSelection() {
        calendarHeaderState = .idle
        availableSlotsState = .idle
        selectedSlot = nil
        slotsCache.removeAll()
    }

    func updateClientQuery(_ query: String) {
        guard query != clientQuery else { return }
        clientQuery = query
        searchTask?.cancel()

        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            await loadClients(reset: true)
        }
    }

    func loadClientsIfNeeded() async {
        guard clientsState.data == nil else { return }
        await loadClients(reset: true)
    }

    func loadMoreClientsIfNeeded(currentClient: BusinessClient?) async {
        guard canLoadMoreClients, !isLoadingMoreClients else { return }
        guard let currentClient, currentClient.id == clientsState.data?.last?.id else { return }

        isLoadingMoreClients = true
        await loadClients(reset: false)
        isLoadingMoreClients = false
    }

    private func fetchClientsPage() async throws -> PaginatedResponse<BusinessClient> {
        try await getBusinessClientsUseCase(
            businessId: businessId,
            query: clientQuery.isEmpty ? nil : clientQuery,
            page: currentClientsPage,
            limit: Self.clientsPageLimit
        )
    }

    private func loadClients(reset: Bool) async {
        if reset {
            currentClientsPage = 1
            canLoadMoreClients = true
            clientsState = .loading
        }

        do {
            let response = reset
                ? try await withLoading { try await self.fetchClientsPage() }
                : try await fetchClientsPage()
            guard !Task.isCancelled else { return }

            let existing = reset ? [] : (clientsState.data ?? [])
            let existingIds = Set(existing.map(\.id))
            let newClients = existing + response.results.filter { !existingIds.contains($0.id) }
            clientsState = .success(newClients)

            let loadedCount = (currentClientsPage - 1) * Self.clientsPageLimit + response.results.count
            canLoadMoreClients = loadedCount < response.count && !response.results.isEmpty
            if canLoadMoreClients { currentClientsPage += 1 }
        } catch {
            guard !Task.isCancelled else { return }
            if reset {
                clientsState = .error(logger.userMessage(for: error, context: "Loading Business Clients"))
            }
        }
    }

    func selectClient(_ client: BusinessClient) {
        selectedClient = client
    }

    func createClient(fullname: String, phone: String?) async -> Bool {
        isCreatingClient = true

        do {
            let client = try await withLoading {
                try await createBusinessClientUseCase(businessId: businessId, fullname: fullname, phone: phone)
            }
            selectedClient = client
            isCreatingClient = false
            return true
        } catch {
            isCreatingClient = false
            toastCenter.show(logger.userMessage(for: error, context: "Creating Business Client"), type: .error)
            return false
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

        let startDateStr = currentMonday.asISODateString()
        guard let endDate = calendar.date(byAdding: .day, value: totalDays - 1, to: currentMonday) else { return }
        let endDateStr = endDate.asISODateString()

        do {
            let daysStrings = try await withLoading {
                try await getUserAvailableDaysUseCase(
                    businessId: businessId,
                    employeeId: employeeId,
                    startDate: startDateStr,
                    endDate: endDateStr,
                    slotDuration: totalDuration
                )
            }

            let availableDaysSet = Set(daysStrings)
            calendarHeaderState = .success(CalendarHeaderData(availableDays: availableDaysSet, allCalendarDays: allCalendarDays))

            await loadAvailableTimeSlots(for: selectedDay)
        } catch {
            calendarHeaderState = .error(logger.userMessage(for: error, context: "Loading Calendar Header"))
        }
    }

    func loadAvailableTimeSlots(for date: Date) async {
        selectedDay = date

        let dayStr = date.asISODateString()
        let cacheKey = TimeslotsCacheKey(day: dayStr, duration: totalDuration, employeeId: employeeId)

        if let cachedData = slotsCache[cacheKey] {
            updateSlotsState(with: cachedData)
            return
        }

        if let headerData = calendarHeaderState.data {
            guard headerData.availableDays.contains(dayStr) else {
                availableSlotsState = .success([])
                return
            }
        }

        availableSlotsState = .loading

        do {
            let availableDayData = try await withLoading {
                try await getUserAvailableTimeslotsUseCase(
                    businessId: businessId,
                    employeeId: employeeId,
                    slotDuration: totalDuration,
                    day: dayStr
                )
            }

            slotsCache[cacheKey] = availableDayData
            updateSlotsState(with: availableDayData)
        } catch {
            availableSlotsState = .error(logger.userMessage(for: error, context: "Loading Available Time Slots"))
        }
    }

    private func updateSlotsState(with availableDay: AvailableDay) {
        availableSlotsState = .success(availableDay.isClosed ? [] : availableDay.availableSlots)
    }

    func onDaySelected(date: Date) async {
        await loadAvailableTimeSlots(for: date)
    }

    func selectSlot(_ slot: Slot) {
        selectedSlot = slot
    }

    func refreshTimeSlotsForCurrentDay() async {
        let dayStr = selectedDay.asISODateString()
        let cacheKey = TimeslotsCacheKey(day: dayStr, duration: totalDuration, employeeId: employeeId)

        slotsCache.removeValue(forKey: cacheKey)

        do {
            let freshDayData = try await getUserAvailableTimeslotsUseCase(
                businessId: businessId,
                employeeId: employeeId,
                slotDuration: totalDuration,
                day: dayStr
            )

            slotsCache[cacheKey] = freshDayData
            updateSlotsState(with: freshDayData)
        } catch {
            logger.error("ERROR: on refreshing time slots: \(error.localizedDescription, privacy: .public)")
        }
    }

    func createAppointment() async -> Bool {
        guard let selectedClient, let selectedSlot else { return false }

        isSaving = true

        let request = AppointmentOwnClientCreateRequestDTO(
            startDate: selectedSlot.startDateUtc,
            endDate: selectedSlot.endDateUtc,
            userId: targetUserId,
            businessClientId: selectedClient.id,
            paymentCurrencyId: 1,
            productVariants: linkedItems.toProductVariantsDto()
        )

        do {
            try await withLoading {
                try await createOwnClientAppointmentUseCase(request: request)
            }
            isSaving = false
            return true
        } catch {
            isSaving = false
            toastCenter.show(logger.userMessage(for: error, context: "Creating Own Client Appointment"), type: .error)
            return false
        }
    }
}
