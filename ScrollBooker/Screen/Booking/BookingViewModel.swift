//
//  BookingViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import Foundation
import Observation

struct CalendarHeaderData: Equatable {
    let availableDays: Set<String>
    let allCalendarDays: [Date]
}

struct TimeslotsCacheKey: Hashable, Sendable {
    let day: String
    let duration: Int
    let employeeId: Int?
}

@Observable
@MainActor
final class BookingViewModel {
    private(set) var viewState: FeatureState<BookingFlow> = .idle

    let params: BookingNavigationParams
    private let getBookingFlowUseCase: GetBookingFlowUseCase
    private let getUserAvailableDaysUseCase: GetUserAvailableDaysUseCase
    private let getUserAvailableTimeslotsUseCase: GetUserAvailableTimeslotsUseCase
    private let createScrollBookerAppointmentUseCase: CreateScrollBookerAppointmentUseCase

    var isSaving: Bool = false
    var isRefreshing: Bool = false
    private(set) var operationErrorMessage: String? = nil
    private(set) var selectedBookingItems: [SelectedBookingItem] = []

    private(set) var calendarHeaderState: FeatureState<CalendarHeaderData> = .idle
    private(set) var availableSlotsState: FeatureState<[Slot]> = .idle

    var selectedDay: Date = Date()
    var selectedSlot: Slot? = nil
    var selectedEmployeeId: Int?

    private var slotsCache: [TimeslotsCacheKey: AvailableDay] = [:]

    private var isEmployee: Bool {
        params.userId != params.businessOwnerId
    }

    var shouldSelectSpecialist: Bool {
        guard let bookingFlow = viewState.data else { return false }
        return bookingFlow.business.hasEmployees && !isEmployee
    }

    var bookingTotals: BookingTotals {
        let sumPrice = selectedBookingItems.reduce(Decimal(0)) { total, item in
            if let employeeId = selectedEmployeeId {
                let specificOffering = item.offerings.first(where: { $0.user.id == employeeId })
                return total + (specificOffering?.priceWithDiscount ?? 0)
            } else {
                return total + (item.offerings.first?.priceWithDiscount ?? 0)
            }
        }

        let sumDuration = selectedBookingItems.reduce(0) { total, item in
            total + item.variantDuration
        }

        return BookingTotals(totalPrice: sumPrice, totalDuration: sumDuration)
    }

    init(
        params: BookingNavigationParams,
        getBookingFlowUseCase: GetBookingFlowUseCase,
        getUserAvailableDaysUseCase: GetUserAvailableDaysUseCase,
        getUserAvailableTimeslotsUseCase: GetUserAvailableTimeslotsUseCase,
        createScrollBookerAppointmentUseCase: CreateScrollBookerAppointmentUseCase
    ) {
        self.params = params
        self.getBookingFlowUseCase = getBookingFlowUseCase
        self.getUserAvailableDaysUseCase = getUserAvailableDaysUseCase
        self.getUserAvailableTimeslotsUseCase = getUserAvailableTimeslotsUseCase
        self.createScrollBookerAppointmentUseCase = createScrollBookerAppointmentUseCase

        if params.userId != params.businessOwnerId {
            self.selectedEmployeeId = params.userId
        } else {
            self.selectedEmployeeId = nil
        }
    }

    func loadBookingFlow() async {
        guard viewState.data == nil else { return }
        guard viewState != .loading else { return }

        viewState = .loading
        operationErrorMessage = nil

        let employeeId = isEmployee ? params.userId : nil

        do {
            let result = try await withLoading {
                try await getBookingFlowUseCase(
                    businessId: params.businessId,
                    employeeId: employeeId
                )
            }
            viewState = .success(result)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            viewState = .error(message)
        }
    }

    func setSelectedEmployeeId(_ id: Int) {
        self.selectedEmployeeId = id
    }

    func selectBookingItem(_ item: SelectedBookingItem) {
        if let index = selectedBookingItems.firstIndex(where: { $0.productId == item.productId }) {
            let existingItem = selectedBookingItems[index]

            if existingItem.variantId == item.variantId {
                selectedBookingItems.remove(at: index)
            } else {
                selectedBookingItems[index] = item
            }
        } else {
            selectedBookingItems.append(item)
        }
    }

    func removeBookingItem(_ item: SelectedBookingItem) {
        if let index = selectedBookingItems.firstIndex(where: { $0.productId == item.productId }) {
            selectedBookingItems.remove(at: index)

            if selectedBookingItems.isEmpty {
                self.selectedEmployeeId = nil
            }
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

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDateStr = formatter.string(from: currentMonday)
        guard let endDate = calendar.date(byAdding: .day, value: totalDays - 1, to: currentMonday) else { return }
        let endDateStr = formatter.string(from: endDate)

        do {
            let daysStrings = try await withLoading {
                try await getUserAvailableDaysUseCase(
                    businessId: params.businessId,
                    employeeId: selectedEmployeeId,
                    startDate: startDateStr,
                    endDate: endDateStr,
                    slotDuration: bookingTotals.totalDuration
                )
            }

            let availableDaysSet = Set(daysStrings)
            calendarHeaderState = .success(CalendarHeaderData(availableDays: availableDaysSet, allCalendarDays: allCalendarDays))

            await loadAvailableTimeSlots(for: selectedDay)

        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            calendarHeaderState = .error(message)
        }
    }

    func loadAvailableTimeSlots(for date: Date) async {
        self.selectedDay = date

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dayStr = formatter.string(from: date)

        let cacheKey = TimeslotsCacheKey(
            day: dayStr,
            duration: bookingTotals.totalDuration,
            employeeId: selectedEmployeeId
        )

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
                    businessId: params.businessId,
                    employeeId: selectedEmployeeId,
                    slotDuration: bookingTotals.totalDuration,
                    day: dayStr
                )
            }

            slotsCache[cacheKey] = availableDayData
            updateSlotsState(with: availableDayData)

        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            availableSlotsState = .error(message)
        }
    }

    private func updateSlotsState(with availableDay: AvailableDay) {
        if availableDay.isClosed || availableDay.availableSlots.isEmpty {
            availableSlotsState = .success([])
        } else {
            availableSlotsState = .success(availableDay.availableSlots)
        }
    }

    func onDaySelected(date: Date) async {
        await loadAvailableTimeSlots(for: date)
    }

    func onSlotSelected(slot: Slot) {
        self.selectedSlot = slot
    }

    func refreshTimeSlotsForCurrentDay() async {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dayStr = formatter.string(from: selectedDay)

        let cacheKey = TimeslotsCacheKey(
            day: dayStr,
            duration: bookingTotals.totalDuration,
            employeeId: selectedEmployeeId
        )

        slotsCache.removeValue(forKey: cacheKey)

        isRefreshing = true

        do {
            let freshDayData = try await getUserAvailableTimeslotsUseCase(
                businessId: params.businessId,
                employeeId: selectedEmployeeId,
                slotDuration: bookingTotals.totalDuration,
                day: dayStr
            )

            slotsCache[cacheKey] = freshDayData
            updateSlotsState(with: freshDayData)

        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            operationErrorMessage = message
        }

        isRefreshing = false
    }

    @discardableResult
    func createAppointment() async -> Result<Void, Error> {
        isSaving = true
        operationErrorMessage = nil

        guard let slot = selectedSlot,
              !slot.startDateUtc.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !slot.endDateUtc.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {

            let validationError = NSError(
                domain: "CreateAppointment",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Datele furnizate pentru programare sunt invalide."]
            )
            print("🚨 ERROR: on Creating ScrollBooker Appointment, the provided data are invalid")

            isSaving = false
            self.operationErrorMessage = validationError.localizedDescription
            return .failure(validationError)
        }

        let appointmentRequest = AppointmentScrollBookerCreateRequest(
            startDate: slot.startDateUtc,
            endDate: slot.endDateUtc,
            productVariants: selectedBookingItems.toProductVariantsDto(),
            paymentCurrencyId: 1
        )

        do {
            _ = try await withLoading {
                try await createScrollBookerAppointmentUseCase(request: appointmentRequest)
            }

            isSaving = false
            return .success(())

        } catch {
            isSaving = false
            print("🚨 ERROR: onCreating ScrollBooker Appointment \(error)")

            let friendlyError = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            self.operationErrorMessage = friendlyError

            return .failure(error)
        }
    }
}
