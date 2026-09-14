//
//  ApproveBusinessUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

final class ApproveBusinessUseCase {
    private let repository: BusinessRepository

    init(repository: BusinessRepository) {
        self.repository = repository
    }

    func callAsFunction(userId: Int) async throws -> NoContent {
        try await repository.approveBusiness(userId: userId)
    }
}
