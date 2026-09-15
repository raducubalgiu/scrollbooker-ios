//
//  GetAllServiceDomainsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

final class GetAllServiceDomainsUseCase {
    private let repository: ServiceDomainRepository

    init(repository: ServiceDomainRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws -> [ServiceDomain] {
        try await repository.getAllServiceDomains()
    }
}
