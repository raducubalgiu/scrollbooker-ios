//
//  CollectGenderViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class CollectGenderViewModel {
    private let session: SessionManager
    private let collectClientGenderUseCase: CollectClientGenderUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Onboarding")

    var selectedGender: GenderTypeEnum?
    var isSaving = false
    var saveError: String?

    var isSubmitEnabled: Bool {
        selectedGender != nil && !isSaving
    }

    init(session: SessionManager, collectClientGenderUseCase: CollectClientGenderUseCase) {
        self.session = session
        self.collectClientGenderUseCase = collectClientGenderUseCase
    }

    @discardableResult
    func collectGender() async -> Bool {
        guard let selectedGender else { return false }

        isSaving = true
        saveError = nil

        do {
            let authState = try await withLoading {
                try await self.collectClientGenderUseCase(gender: selectedGender.rawValue)
            }
            session.updateAuthState(authState)
            isSaving = false
            return true
        } catch {
            saveError = logger.userMessage(for: error, context: "Collecting Client Gender")
            isSaving = false
            return false
        }
    }
}
