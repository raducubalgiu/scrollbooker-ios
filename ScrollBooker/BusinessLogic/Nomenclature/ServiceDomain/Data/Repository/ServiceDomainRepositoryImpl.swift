//
//  ServiceDomainRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation

final class ServiceDomainRepositoryImpl: ServiceDomainRepository {
    private let api: ServiceDomainApiService
        
    init(api: ServiceDomainApiService) {
        self.api = api
    }
    
    func selectedDomainsByBusiness(businessId: Int) async throws -> [SelectedServiceDomainsWithServices] {
        let dtoResponse = try await api.selectedDomainsByBusiness(businessId: businessId)
                
        return dtoResponse.map { dto in
            SelectedServiceDomainsWithServices(dto: dto)
        }
    }
    
    func updateBusinessServices(businessId: Int, request: BusinessUpdateServiesRequest) async throws -> [SelectedServiceDomainsWithServices] {
        let dtoResponse = try await api.updateBusinessServices(businessId: businessId, request: request)
        
        return dtoResponse.map { dto in
            SelectedServiceDomainsWithServices(dto: dto)
        }
    }
}
