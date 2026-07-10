//
//  ServiceDomainRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

protocol ServiceDomainRepository: Sendable {
    func selectedDomainsByBusiness(businessId: Int) async throws -> [SelectedServiceDomainsWithServices]
    func updateBusinessServices(businessId: Int, request: BusinessUpdateServiesRequest) async throws -> [SelectedServiceDomainsWithServices]
}
