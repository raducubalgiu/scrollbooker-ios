//
//  DeletePostViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class DeletePostViewModel {
    private(set) var isDeleting = false
    private(set) var errorMessage: String?

    private let deletePostUseCase: DeletePostUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "DeletePost")

    init(deletePostUseCase: DeletePostUseCase) {
        self.deletePostUseCase = deletePostUseCase
    }

    func deletePost(id: Int) async -> Bool {
        guard !isDeleting else { return false }

        isDeleting = true
        errorMessage = nil

        do {
            _ = try await withLoading {
                try await deletePostUseCase(id: id)
            }
            isDeleting = false
            return true
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Deleting Post")
            isDeleting = false
            return false
        }
    }
}
