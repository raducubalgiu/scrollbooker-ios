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
        let remaining = minDuration - duration
        try await Task.sleep(for: remaining)
    }
    
    return result!
}
