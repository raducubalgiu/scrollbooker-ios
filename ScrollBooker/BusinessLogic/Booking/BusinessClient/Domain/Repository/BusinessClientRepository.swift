//
//  BusinessClientRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

protocol BusinessClientRepository: Sendable {
    func getBusinessClients(businessId: Int, query: String?, page: Int, limit: Int) async throws -> PaginatedResponse<BusinessClient>
    func createBusinessClient(businessId: Int, fullname: String, phone: String?) async throws -> BusinessClient
}
