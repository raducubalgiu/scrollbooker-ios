//
//  CollectBusinessSchedulesViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class CollectBusinessSchedulesViewModel {
    private let session: SessionManager
    private let getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase
    private let collectBusinessSchedulesUseCase: CollectBusinessSchedulesUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Onboarding")

    private(set) var viewState: FeatureState<[Schedule]> = .idle
    var isSaving = false
    var saveError: String?

    init(
        session: SessionManager,
        getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase,
        collectBusinessSchedulesUseCase: CollectBusinessSchedulesUseCase
    ) {
        self.session = session
        self.getSchedulesByUserIdUseCase = getSchedulesByUserIdUseCase
        self.collectBusinessSchedulesUseCase = collectBusinessSchedulesUseCase
    }

    func loadSchedules() async {
        guard viewState.data == nil else { return }
        guard viewState != .loading else { return }

        viewState = .loading

        guard let userId = session.userInfo?.id else {
            logger.error("ERROR: User ID not found in session")
            viewState = .error(String(localized: "somethingWentWrong"))
            return
        }

        do {
            let data = try await withLoading {
                try await getSchedulesByUserIdUseCase(userId: userId)
            }
            viewState = .success(data)
        } catch {
            viewState = .error(logger.userMessage(for: error, context: "Fetching Schedules"))
        }
    }

    func updateLocalScheduleRow(updatedSchedule: Schedule) {
        guard var currentSchedules = viewState.data else { return }

        if let index = currentSchedules.firstIndex(where: { $0.id == updatedSchedule.id }) {
            currentSchedules[index] = updatedSchedule
            viewState = .success(currentSchedules)
        }
    }

    @discardableResult
    func collectBusinessSchedules() async -> Bool {
        guard let currentSchedules = viewState.data else { return false }
        guard !isSaving else { return false }

        isSaving = true
        saveError = nil

        do {
            let authState = try await withLoading {
                try await self.collectBusinessSchedulesUseCase(schedules: currentSchedules)
            }
            session.updateAuthState(authState)
            isSaving = false
            return true
        } catch {
            saveError = logger.userMessage(for: error, context: "Collecting Business Schedules")
            isSaving = false
            return false
        }
    }
}
