//
//  BusinessDomainRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

import Foundation

final class BusinessDomainRepositoryImpl: BusinessDomainRepository {
    private let api: BusinessDomainApiService
        
    init(api: BusinessDomainApiService) {
        self.api = api
    }
    
    func getAllBusinessDomains() async throws -> [BusinessDomain] {
        let dtoResponse = try await api.getAllBusinessDomains()
                
        return dtoResponse.map { dto in
            BusinessDomain(dto: dto)
        }
    }
}
