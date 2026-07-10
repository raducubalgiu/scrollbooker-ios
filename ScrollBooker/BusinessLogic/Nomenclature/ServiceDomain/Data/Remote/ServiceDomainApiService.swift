//
//  BusinessDomainApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation

protocol ServiceDomainApiService: Sendable {
    func selectedDomainsByBusiness(businessId: Int) async throws -> [SelectedServiceDomainsWithServicesDto]
    func updateBusinessServices(businessId: Int, request: BusinessUpdateServiesRequest) async throws -> [SelectedServiceDomainsWithServicesDto]
}

final class ServiceDomainAPIImpl: ServiceDomainApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func selectedDomainsByBusiness(businessId: Int) async throws -> [SelectedServiceDomainsWithServicesDto] {
        return try await client.request(
            "businesses/\(businessId)/service-domains",
            method: .get
        )
    }
    
    func updateBusinessServices(businessId: Int, request: BusinessUpdateServiesRequest) async throws -> [SelectedServiceDomainsWithServicesDto] {
        return try await client.request(
            "businesses/\(businessId)/update-services",
            method: .put,
            body: request
        )
    }
}
