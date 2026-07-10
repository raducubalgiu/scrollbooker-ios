//
//  GetSelectedDomainsByBusinessUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

final class GetSelectedDomainsByBusinesssUseCase {
    private let repository: ServiceDomainRepository

    init(repository: ServiceDomainRepository) {
        self.repository = repository
    }

    func callAsFunction(businessId: Int) async throws -> [SelectedServiceDomainsWithServices] {
        try await repository.selectedDomainsByBusiness(businessId: businessId)
    }
}
