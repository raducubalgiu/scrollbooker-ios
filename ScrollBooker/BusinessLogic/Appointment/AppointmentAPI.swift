//
//  AppointmentAPI.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.09.2025.
//

import Foundation

protocol AppointmentAPI {
    func getUserAppointments(
        page: Int,
        limit: Int,
        asCustomer: Bool?,
        bearer: String
    ) async throws -> PaginatedResponse<Appointment>
}

final class AppointmentAPIImpl: AppointmentAPI {
    private let client: APIClient
    init(client: APIClient) {
        self.client = client
    }
    
    func getUserAppointments(page: Int, limit: Int, asCustomer: Bool?, bearer: String) async throws -> PaginatedResponse<Appointment> {
        var query: [String: String] = [
            "page": "\(page)",
            "limit": "\(limit)",
        ]
        if let asCustomer = asCustomer {
            query["as_customer"] = asCustomer ? "true" : "false"
        }
        
        let dto: PaginatedResponseDTO<AppointmentDTO> = try await client.request(
            "appointments/",
            bearer: bearer,
            query: query
        )
        
        return try PaginatedResponse(dto) { try Appointment(dto: $0) }
    }
}
