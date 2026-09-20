//
//  BookingViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import Foundation
import Observation
import OSLog

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
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Booking")

    let params: BookingNavigationParams
    private let getBookingFlowUseCase: GetBookingFlowUseCase
    private let getUserAvailableDaysUseCase: GetUserAvailableDaysUseCase
    private let getUserAvailableTimeslotsUseCase: GetUserAvailableTimeslotsUseCase
    private let createScrollBookerAppointmentUseCase: CreateScrollBookerAppointmentUseCase
    private let getAppointmentByIdUseCase: GetAppointmentByIdUseCase

    var isSaving: Bool = false
    var isRefreshing: Bool = false
    private(set) var operationErrorMessage: String? = nil
    private(set) var selectedBookingItems: [SelectedBookingItem] = []
    private(set) var isInitialSelectionProcessed = false
    private(set) var rebookingInfoMessage: String?
    private(set) var scrollToSectionId: Int?
    private(set) var productPendingVariantSelection: Product?

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
            let employeeOffering = selectedEmployeeId.flatMap { employeeId in
                item.offerings.first(where: { $0.user.id == employeeId })
            }
            let price = employeeOffering?.priceWithDiscount ?? item.offerings.first?.priceWithDiscount ?? 0
            return total + price
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
        createScrollBookerAppointmentUseCase: CreateScrollBookerAppointmentUseCase,
        getAppointmentByIdUseCase: GetAppointmentByIdUseCase
    ) {
        self.params = params
        self.getBookingFlowUseCase = getBookingFlowUseCase
        self.getUserAvailableDaysUseCase = getUserAvailableDaysUseCase
        self.getUserAvailableTimeslotsUseCase = getUserAvailableTimeslotsUseCase
        self.createScrollBookerAppointmentUseCase = createScrollBookerAppointmentUseCase
        self.getAppointmentByIdUseCase = getAppointmentByIdUseCase

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
            viewState = .error(logger.userMessage(for: error, context: "Loading Booking Flow"))
        }
    }

    func processInitialSelectionIfNeeded() async {
        guard !isInitialSelectionProcessed else { return }
        isInitialSelectionProcessed = true

        guard let bookingFlow = viewState.data else { return }

        try? await Task.sleep(for: .milliseconds(350))

        if let appointmentId = params.appointmentId {
            await processAppointmentRebooking(appointmentId: appointmentId, bookingFlow: bookingFlow)
        } else if let selectedProductId = params.selectedProductId {
            await processSelectedProduct(id: selectedProductId, bookingFlow: bookingFlow)
        }
    }

    private func processAppointmentRebooking(appointmentId: Int, bookingFlow: BookingFlow) async {
        do {
            let appointment = try await getAppointmentByIdUseCase(id: appointmentId)

            let variantsWithProduct: [(product: Product, variant: ProductVariant)] = bookingFlow.products.data
                .flatMap { $0.products }
                .flatMap { product in product.variants.map { (product, $0) } }

            var unavailableCount = 0
            var firstMatchedProductId: Int?

            for appointmentProduct in appointment.products {
                let match = appointmentProduct.productVariantId.flatMap { variantId in
                    variantsWithProduct.first { $0.variant.id == variantId }
                }
                let isStillOffered = match?.variant.offerings.contains { $0.id == appointmentProduct.offeringId } ?? false

                if let match, isStillOffered {
                    selectBookingItem(match.variant.toBookingItem(product: match.product))
                    if firstMatchedProductId == nil {
                        firstMatchedProductId = match.product.id
                    }
                } else {
                    unavailableCount += 1
                }
            }

            if unavailableCount > 0 {
                rebookingInfoMessage = String(localized: "message_info_some_services_unavailable")
            }

            if let firstMatchedProductId {
                scrollToSectionId = sectionId(forProductId: firstMatchedProductId, in: bookingFlow)
            }
        } catch {
            logger.error("ERROR: on Fetching Appointment for Book Again: \(error.localizedDescription)")
        }
    }

    private func processSelectedProduct(id: Int, bookingFlow: BookingFlow) async {
        guard let targetProduct = bookingFlow.products.data
            .flatMap({ $0.products })
            .first(where: { $0.id == id }) else { return }

        scrollToSectionId = sectionId(forProductId: targetProduct.id, in: bookingFlow)

        if targetProduct.variants.count > 1 {
            try? await Task.sleep(for: .milliseconds(300))
            productPendingVariantSelection = targetProduct
        } else if let firstVariant = targetProduct.variants.first {
            selectBookingItem(firstVariant.toBookingItem(product: targetProduct))
        }
    }

    private func sectionId(forProductId productId: Int, in bookingFlow: BookingFlow) -> Int? {
        bookingFlow.products.data.first { group in
            group.products.contains { $0.id == productId }
        }?.service.id
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
            calendarHeaderState = .error(logger.userMessage(for: error, context: "Loading Calendar Header"))
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
            availableSlotsState = .error(logger.userMessage(for: error, context: "Loading Available Time Slots"))
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
            operationErrorMessage = logger.userMessage(for: error, context: "Refreshing Time Slots")
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
            logger.error("ERROR: on Creating ScrollBooker Appointment, the provided data are invalid")

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
            self.operationErrorMessage = logger.userMessage(for: error, context: "Creating ScrollBooker Appointment")

            return .failure(error)
        }
    }
}
