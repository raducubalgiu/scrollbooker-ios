//
//  AppointmentApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//
//  API service for appointment-related remote calls. Returns DTOs; repository maps to domain models.
//

import Foundation

protocol AppointmentApiService: Sendable {
    func fetchUserAppointments(page: Int, limit: Int) async throws -> PaginatedResponseDTO<AppointmentDto>
    func getAppointmentById(id: Int) async throws -> AppointmentDto
}

final class AppointmentAPIImpl: AppointmentApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func fetchUserAppointments(page: Int, limit: Int) async throws -> PaginatedResponseDTO<AppointmentDto> {
        let query: [String: String] = [
            "page": "\(page)",
            "limit": "\(limit)"
        ]
        
        return try await client.request(
            "appointments/me",
            method: .get,
            query: query
        )
    }
    
    func getAppointmentById(id: Int) async throws -> AppointmentDto {
        return try await client.request(
            "appointments/\(id)",
            method: .get
        )
    }
}
