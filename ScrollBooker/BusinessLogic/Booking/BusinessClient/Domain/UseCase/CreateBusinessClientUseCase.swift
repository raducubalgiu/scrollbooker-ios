//
//  CreateBusinessClientUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

final class CreateBusinessClientUseCase {
    private let repository: BusinessClientRepository

    init(repository: BusinessClientRepository) {
        self.repository = repository
    }

    func callAsFunction(businessId: Int, fullname: String, phone: String?) async throws -> BusinessClient {
        try await repository.createBusinessClient(businessId: businessId, fullname: fullname, phone: phone)
    }
}
