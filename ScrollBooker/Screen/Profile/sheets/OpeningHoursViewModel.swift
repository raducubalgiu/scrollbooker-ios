//
//  OpeningHoursViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class OpeningHoursViewModel {
    private(set) var viewState: FeatureState<[Schedule]> = .idle

    private let getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "OpeningHours")

    init(getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase) {
        self.getSchedulesByUserIdUseCase = getSchedulesByUserIdUseCase
    }

    // This instance is held for a screen's whole lifetime (see the OpeningHoursSheetView
    // call sites), always for the same userId — so once loaded, this guard alone is
    // enough to skip a pointless re-fetch on every sheet reopen.
    func loadSchedules(userId: Int) async {
        guard viewState == .idle else { return }
        viewState = .loading

        do {
            let schedules = try await withLoading {
                try await getSchedulesByUserIdUseCase(userId: userId)
            }
            viewState = .success(schedules)
        } catch {
            viewState = .error(logger.userMessage(for: error, context: "Loading Opening Hours"))
        }
    }
}
