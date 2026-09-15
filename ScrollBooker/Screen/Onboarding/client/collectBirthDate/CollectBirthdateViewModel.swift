//
//  CollectBirthdateViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class CollectBirthdateViewModel {
    private let session: SessionManager
    private let collectClientBirthdateUseCase: CollectClientBirthdateUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Onboarding")

    var selectedBirthdate: Date = Date()
    var isSaving = false
    var saveError: String?

    init(session: SessionManager, collectClientBirthdateUseCase: CollectClientBirthdateUseCase) {
        self.session = session
        self.collectClientBirthdateUseCase = collectClientBirthdateUseCase
    }

    @discardableResult
    func collectBirthdate(skip: Bool = false) async -> Bool {
        isSaving = true
        saveError = nil

        var birthdate: String?
        if !skip {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFullDate]
            birthdate = formatter.string(from: selectedBirthdate)
        }

        do {
            let authState = try await withLoading {
                try await self.collectClientBirthdateUseCase(birthdate: birthdate)
            }
            session.updateAuthState(authState)
            isSaving = false
            return true
        } catch {
            saveError = logger.userMessage(for: error, context: "Collecting Client Birthdate")
            isSaving = false
            return false
        }
    }
}
