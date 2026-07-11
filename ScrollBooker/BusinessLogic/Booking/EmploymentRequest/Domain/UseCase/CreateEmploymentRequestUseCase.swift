//
//  CreateEmploymentRequestUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

final class CreateEmploymentRequestUseCase {
    private let repository: EmploymentRequestRepository

    init(repository: EmploymentRequestRepository) {
        self.repository = repository
    }

    func callAsFunction(
        employmentId: Int,
        professionId: Int,
        consentId: Int
    ) async throws -> NoContent {
        let request = EmploymentRequestCreate(
            employee_id: employmentId,
            profession_id: professionId,
            consent_id: consentId
        )
            
        return try await repository.createEmploymentRequest(request: request)
    }
}
