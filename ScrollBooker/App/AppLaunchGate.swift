//
//  AppLaunchGate.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.09.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class AppLaunchGate {
    private(set) var isFeedReady = false
    private var watchdogStarted = false

    func markFeedReady() {
        isFeedReady = true
    }

    func startWatchdogIfNeeded() {
        guard !watchdogStarted, !isFeedReady else { return }
        watchdogStarted = true

        Task {
            try? await Task.sleep(for: .seconds(6))
            markFeedReady()
        }
    }
}
