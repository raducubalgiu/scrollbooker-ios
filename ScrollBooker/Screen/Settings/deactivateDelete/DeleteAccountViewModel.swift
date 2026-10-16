//
//  DeleteAccountViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.10.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class DeleteAccountViewModel {
    private let session: SessionManager
    private let deleteAccountUseCase: DeleteAccountUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Settings")

    var isDeleting = false
    var errorMessage: String?

    init(session: SessionManager, deleteAccountUseCase: DeleteAccountUseCase) {
        self.session = session
        self.deleteAccountUseCase = deleteAccountUseCase
    }

    @discardableResult
    func deleteAccount() async -> Bool {
        isDeleting = true
        errorMessage = nil

        do {
            _ = try await withLoading {
                try await self.deleteAccountUseCase()
            }
            isDeleting = false
            session.logout()
            return true
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Deleting Account")
            isDeleting = false
            return false
        }
    }
}
