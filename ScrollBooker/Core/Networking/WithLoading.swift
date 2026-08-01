//
//  WithLoading.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.07.2026.
//

import Foundation

func withLoading<T>(
    minLoadingMs: Int64 = 300,
    block: () async throws -> T
) async throws -> T {
    let clock = ContinuousClock()
    var result: T?

    let duration = try await clock.measure {
        result = try await block()
    }

    let minDuration = Duration.milliseconds(minLoadingMs)
    if duration < minDuration {
        try await Task.sleep(for: minDuration - duration)
    }

    return result!
}

func withLoading<T>(
    minLoadingMs: Int64 = 300,
    block: () async -> T
) async -> T {
    let clock = ContinuousClock()
    var result: T?

    let duration = await clock.measure {
        result = await block()
    }

    let minDuration = Duration.milliseconds(minLoadingMs)
    if duration < minDuration {
        try? await Task.sleep(for: minDuration - duration)
    }

    return result!
}
