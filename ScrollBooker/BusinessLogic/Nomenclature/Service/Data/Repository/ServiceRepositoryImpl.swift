//
//  ServiceRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

final class ServiceRepositoryImpl: ServiceRepository {
    private let api: ServicesApiService

    init(api: ServicesApiService) {
        self.api = api
    }

    func getServicesByServiceDomain(serviceDomainId: Int) async throws -> [ServiceWithFilters] {
        let dtoResponse = try await api.getServicesByServiceDomainId(serviceDomainId)

        return dtoResponse.map { dto in
            ServiceWithFilters(dto: dto)
        }
    }
}
