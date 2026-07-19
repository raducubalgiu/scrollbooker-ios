//
//  GetAllBusinessDomainsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

final class GetAllBusinessDomainsUseCase {
    private let repository: BusinessDomainRepository

    init(repository: BusinessDomainRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws -> [BusinessDomain] {
        try await repository.getAllBusinessDomains()
    }
}
