//
//  EmployeeApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

protocol EmployeeApiService: Sendable {
    func getEmployeesByOwner(businessOwnerId: Int) async throws -> [EmployeeDto]
}

final class EmployeeAPIImpl: EmployeeApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getEmployeesByOwner(businessOwnerId: Int) async throws -> [EmployeeDto] {
        return try await client.request(
            "businesses/owner/\(businessOwnerId)/employees",
            method: .get,
        )
    }
}
