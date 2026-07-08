//
//  WithVisibleLoading.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation

@MainActor
protocol HasLoadingState: AnyObject {
    var isLoading: Bool { get set }
    var errorMessage: String? { get set }
}

extension HasLoadingState {
    @discardableResult
    
    func withVisibleLoading<T>(
        minDuration: Duration = .milliseconds(300),
        _ operation: () async throws -> T
    ) async rethrows -> T {
        isLoading = true
        let clock = ContinuousClock()
        let start = clock.now

        defer { isLoading = false }

        let value = try await operation()

        let elapsed = start.duration(to: clock.now)
        if elapsed < minDuration {
            try? await Task.sleep(for: minDuration - elapsed)
        }

        return value
    }
}
