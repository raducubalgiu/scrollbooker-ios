//
//  GetUserEmploymentRequestsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

final class GetUserEmploymentRequestsUseCase {
    private let repository: EmploymentRequestRepository

    init(repository: EmploymentRequestRepository) {
        self.repository = repository
    }

    func callAsFunction(userId: Int) async throws -> [EmploymentRequest] {
        try await repository.getUserEmploymentRequests(userId: userId)
    }
}
