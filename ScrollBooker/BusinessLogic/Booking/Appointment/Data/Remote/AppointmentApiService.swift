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
    func getUserAppointmentsNumber() async throws -> Int
    func getAppointmentById(id: Int) async throws -> AppointmentDto
    func getAppointmentByUserAndPost(userId: Int, postId: Int, lat: Double?, lng: Double?) async throws -> AppointmentDto
    func cancelAppointment(id: Int, request: AppointmentCancelRequest) async throws -> AppointmentDto
    func createScrollBookerAppointment(request: AppointmentScrollBookerCreateRequest) async throws -> NoContent
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
    
    func getUserAppointmentsNumber() async throws -> Int {
        return try await client.request(
            "appointments/count",
            method: .get
        )
    }

    func getAppointmentById(id: Int) async throws -> AppointmentDto {
        return try await client.request(
            "appointments/\(id)",
            method: .get
        )
    }
    
    func getAppointmentByUserAndPost(userId: Int, postId: Int, lat: Double?, lng: Double?) async throws -> AppointmentDto {
        var query: [String: String] = [:]
        if let lat, let lng {
            query["lat"] = "\(lat)"
            query["lng"] = "\(lng)"
        }

        return try await client.request(
            "appointments/users/\(userId)/post/\(postId)",
            method: .get,
            query: query
        )
    }

    func cancelAppointment(id: Int, request: AppointmentCancelRequest) async throws -> AppointmentDto {
            return try await client.request(
                "appointments/\(id)/cancel-appointment",
                method: .put,
                body: request
            )
        }
    
    func createScrollBookerAppointment(request: AppointmentScrollBookerCreateRequest) async throws -> NoContent {
        return try await client.request(
            "appointments/create-scrollbooker-appointment",
            method: .post,
            body: request
        )
    }
}
