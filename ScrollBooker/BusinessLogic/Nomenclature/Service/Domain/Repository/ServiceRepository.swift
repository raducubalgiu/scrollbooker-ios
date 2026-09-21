//
//  ServiceRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

protocol ServiceRepository: Sendable {
    func getServicesByServiceDomain(serviceDomainId: Int) async throws -> [ServiceWithFilters]
}
