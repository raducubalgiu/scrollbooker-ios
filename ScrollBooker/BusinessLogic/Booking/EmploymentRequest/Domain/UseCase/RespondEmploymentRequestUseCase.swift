//
//  RespondEmploymentRequestUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

final class RespondEmploymentRequestUseCase {
    private let repository: EmploymentRequestRepository

    init(repository: EmploymentRequestRepository) {
        self.repository = repository
    }

    func callAsFunction(status: EmploymentRequestStatusEnum, employmentId: Int) async throws -> NoContent {
        try await repository.respondEmploymentRequest(status: status, employmentId: employmentId)
    }
}
