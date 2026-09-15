//
//  CollectBusinessHasEmployeesViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class CollectBusinessHasEmployeesViewModel {
    private let session: SessionManager
    private let collectBusinessHasEmployeesUseCase: CollectBusinessHasEmployeesUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Onboarding")

    var hasEmployees: Bool?
    var isSaving = false
    var saveError: String?

    var isSubmitEnabled: Bool {
        hasEmployees != nil && !isSaving
    }

    init(session: SessionManager, collectBusinessHasEmployeesUseCase: CollectBusinessHasEmployeesUseCase) {
        self.session = session
        self.collectBusinessHasEmployeesUseCase = collectBusinessHasEmployeesUseCase
    }

    @discardableResult
    func collectBusinessHasEmployees() async -> Bool {
        guard let hasEmployees else { return false }

        isSaving = true
        saveError = nil

        do {
            let authState = try await withLoading {
                try await self.collectBusinessHasEmployeesUseCase(hasEmployees: hasEmployees)
            }
            session.updateAuthState(authState)
            isSaving = false
            return true
        } catch {
            saveError = logger.userMessage(for: error, context: "Collecting Business Has Employees")
            isSaving = false
            return false
        }
    }
}
