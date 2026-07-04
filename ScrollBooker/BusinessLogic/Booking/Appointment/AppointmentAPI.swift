//
//  AppointmentAPI.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.09.2025.
//

import Foundation

// MARK: - Protocol
/// Protocol marcat ca Sendable pentru conformarea strictă la modelul de concurență din Swift 6.
protocol AppointmentAPI: Sendable {
    func getUserAppointments(
        page: Int,
        limit: Int,
        asCustomer: Bool?
    ) async throws -> PaginatedResponse<Appointment>
}

// MARK: - Implementare
final class AppointmentAPIImpl: AppointmentAPI {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getUserAppointments(
        page: Int,
        limit: Int,
        asCustomer: Bool?
    ) async throws -> PaginatedResponse<Appointment> {
        // 1) Pregătirea parametrilor de Query (Rămâne neschimbată și curată)
        var query: [String: String] = [
            "page": "\(page)",
            "limit": "\(limit)",
        ]
        
        if let asCustomer = asCustomer {
            query["as_customer"] = asCustomer ? "true" : "false"
        }
        
        // 2) Apelul către APIClient. Am eliminat argumentul `bearer: bearer`.
        // Noul AuthInterceptor va injecta automat token-ul corect înainte ca cererea să plece.
        let dto: PaginatedResponseDTO<AppointmentDto> = try await client.request(
            "appointments/",
            query: query
        )
        
        // 3) Maparea DTO-ului în modelul de domeniu
        return try PaginatedResponse(dto) { try Appointment(dto: $0) }
    }
}
