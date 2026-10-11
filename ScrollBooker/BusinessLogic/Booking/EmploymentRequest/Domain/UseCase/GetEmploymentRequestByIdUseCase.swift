//
//  GetEmploymentRequestByIdUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

final class GetEmploymentRequestByIdUseCase {
    private let repository: EmploymentRequestRepository

    init(repository: EmploymentRequestRepository) {
        self.repository = repository
    }

    func callAsFunction(employmentId: Int) async throws -> EmploymentRequest {
        try await repository.getEmploymentRequestById(employmentId: employmentId)
    }
}
