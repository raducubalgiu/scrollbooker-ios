//
//  MyDashboardViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class MyDashboardViewModel {
    private let getDashboardBookingUseCase: GetDashboardBookingUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Dashboard")

    private(set) var selectedPeriod: DashboardPeriod = .sevenDays
    private(set) var dashboardBookingState: FeatureState<DashboardBooking> = .idle

    var selectedDateRange: DashboardDateRange {
        selectedPeriod.getDateRange()
    }

    init(getDashboardBookingUseCase: GetDashboardBookingUseCase) {
        self.getDashboardBookingUseCase = getDashboardBookingUseCase
    }

    func onPeriodSelected(_ period: DashboardPeriod) {
        guard period != selectedPeriod else { return }
        selectedPeriod = period

        Task {
            await loadDashboardBooking()
        }
    }

    func loadDashboardBooking() async {
        dashboardBookingState = .loading
        let dateRange = selectedDateRange

        do {
            let data = try await withLoading {
                try await getDashboardBookingUseCase(
                    startDate: dateRange.toApiStartDate(),
                    endDate: dateRange.toApiEndDate()
                )
            }

            dashboardBookingState = .success(data)
        } catch {
            logger.error("ERROR: on fetching Dashboard Booking: \(error.localizedDescription)")
            dashboardBookingState = .error(error.localizedDescription)
        }
    }
}
