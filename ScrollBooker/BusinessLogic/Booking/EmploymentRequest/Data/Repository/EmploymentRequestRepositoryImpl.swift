//
//  EmploymentRequestRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation

final class EmploymentRequestRepositoryImpl: EmploymentRequestRepository {
    private let api: EmploymentRequestApiService
        
    init(api: EmploymentRequestApiService) {
        self.api = api
    }
    
    func getUserEmploymentRequests(userId: Int) async throws -> [EmploymentRequest] {
        let dtoResponse = try await api.getUserEmploymentRequests(userId: userId)
        
        return try dtoResponse.map { dto in
            try EmploymentRequest(dto: dto)
        }
    }
    
    func cancelEmploymentRequest(employmentId: Int) async throws -> NoContent {
        return try await api.cancelEmploymentRequest(employmentId: employmentId)
    }
}
