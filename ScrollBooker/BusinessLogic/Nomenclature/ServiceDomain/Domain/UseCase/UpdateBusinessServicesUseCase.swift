//
//  UpdateBusinessServicesUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

final class UpdateBusinessServicesUseCase {
    private let repository: ServiceDomainRepository

    init(repository: ServiceDomainRepository) {
        self.repository = repository
    }

    func callAsFunction(businessId: Int, serviceIds: [Int]) async throws -> [SelectedServiceDomainsWithServices] {
        let request = BusinessUpdateServiesRequest(service_ids: serviceIds)
        
        return try await repository.updateBusinessServices(businessId: businessId, request: request)
    }
}
