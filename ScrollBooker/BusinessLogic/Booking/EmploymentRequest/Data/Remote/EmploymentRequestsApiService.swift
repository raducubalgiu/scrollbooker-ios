//
//  EmploymentRequestsApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation

protocol EmploymentRequestApiService: Sendable {
    func getUserEmploymentRequests(userId: Int) async throws -> [EmploymentRequestDto]
    func getEmploymentRequest(employmentId: Int) async throws -> EmploymentRequestDto
    func cancelEmploymentRequest(employmentId: Int) async throws -> NoContent
    func createEmploymentRequest(request: EmploymentRequestCreate) async throws -> NoContent
    func respondEmploymentRequest(status: EmploymentRequestStatusEnum, employmentId: Int) async throws -> NoContent
}

final class EmploymentRequestAPIImpl: EmploymentRequestApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getUserEmploymentRequests(userId: Int) async throws -> [EmploymentRequestDto] {
        return try await client.request(
            "users/\(userId)/employment-requests",
            method: .get        )
    }
    
    func getEmploymentRequest(employmentId: Int) async throws -> EmploymentRequestDto {
        return try await client.request(
            "employment-requests/\(employmentId)",
            method: .get
        )
    }

    func cancelEmploymentRequest(employmentId: Int) async throws -> NoContent {
        try await client.request(
            "employment-requests/\(employmentId)/cancel",
            method: .delete
        )
    }

    func createEmploymentRequest(request: EmploymentRequestCreate) async throws -> NoContent {
        try await client.request(
            "employment-requests",
            method: .post,
            body: request
        )
    }

    func respondEmploymentRequest(status: EmploymentRequestStatusEnum, employmentId: Int) async throws -> NoContent {
        try await client.request(
            "employment-requests/\(employmentId)",
            method: .put,
            body: EmploymentRequestRespondDto(status: status.rawValue)
        )
    }
}
