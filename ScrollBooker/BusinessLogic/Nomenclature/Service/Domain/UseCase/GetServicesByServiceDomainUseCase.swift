//
//  GetServicesByServiceDomainUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

final class GetServicesByServiceDomainUseCase {
    private let repository: ServiceRepository

    init(repository: ServiceRepository) {
        self.repository = repository
    }

    func callAsFunction(serviceDomainId: Int) async throws -> [ServiceWithFilters] {
        try await repository.getServicesByServiceDomain(serviceDomainId: serviceDomainId)
    }
}
