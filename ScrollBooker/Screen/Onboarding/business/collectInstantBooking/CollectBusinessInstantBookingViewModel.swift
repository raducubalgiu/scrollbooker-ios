//
//  CollectBusinessInstantBookingViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.10.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class CollectBusinessInstantBookingViewModel {
    private let session: SessionManager
    private let collectBusinessInstantBookingUseCase: CollectBusinessInstantBookingUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Onboarding")

    var instantBooking: Bool?
    var isSaving = false
    var saveError: String?

    var hasEmployees: Bool {
        session.userInfo?.hasEmployees ?? false
    }

    var isSubmitEnabled: Bool {
        instantBooking != nil && !isSaving
    }

    init(session: SessionManager, collectBusinessInstantBookingUseCase: CollectBusinessInstantBookingUseCase) {
        self.session = session
        self.collectBusinessInstantBookingUseCase = collectBusinessInstantBookingUseCase
    }

    @discardableResult
    func collectBusinessInstantBooking() async -> Bool {
        guard let instantBooking else { return false }

        isSaving = true
        saveError = nil

        do {
            let authState = try await withLoading {
                try await self.collectBusinessInstantBookingUseCase(instantBooking: instantBooking)
            }
            session.updateAuthState(authState)
            isSaving = false
            return true
        } catch {
            saveError = logger.userMessage(for: error, context: "Collecting Business Instant Booking")
            isSaving = false
            return false
        }
    }
}
