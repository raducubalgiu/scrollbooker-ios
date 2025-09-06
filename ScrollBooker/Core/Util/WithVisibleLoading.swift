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
    // Ruleaza o operatie async, garantand un loading vizibil minim (default 300 ms).
    @discardableResult
    func withVisibleLoading<T> (
        minDuration: Duration = .milliseconds(2000),
        _ operation: () async throws -> T
    ) async rethrows -> T {
        isLoading = true
        let clock = ContinuousClock()
        let start = clock.now
        
        // Asiguram oprirea loading-ului indiferent de ramura
        defer { isLoading = false }
        
        do {
            let value = try await operation()
            
            // Garantam durata minima a indicatorului
            let elapsed = start.duration(to: clock.now)
            if elapsed < minDuration {
                try? await Task.sleep(for: minDuration - elapsed)
            }
            
            return value
        } catch {
            // Garantam durata minima a indicatorului si pe esec
            let elapsed = start.duration(to: clock.now)
            if elapsed < minDuration {
                try? await Task.sleep(for: minDuration - elapsed)
            }
            
            
            errorMessage = (error as NSError).localizedDescription
            throw error
        }
    }
}

@discardableResult
func withVisibleLoading<T>(
    _ owner: HasLoadingState,
    minDuration: Duration = .milliseconds(2000),
    _ operation: () async throws -> T
) async rethrows -> T {
    try await owner.withVisibleLoading(minDuration: minDuration, operation)
}
