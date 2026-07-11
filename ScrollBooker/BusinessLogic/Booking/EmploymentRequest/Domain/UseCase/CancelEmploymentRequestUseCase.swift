//
//  CancelEmploymentRequestUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

final class CancelEmploymentRequestUseCase {
    private let repository: EmploymentRequestRepository

    init(repository: EmploymentRequestRepository) {
        self.repository = repository
    }

    func callAsFunction(employmentId: Int) async throws -> NoContent {
        try await repository.cancelEmploymentRequest(employmentId: employmentId)
    }
}
