//
//  AppointmentRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//
//  Repository implementation that uses AppointmentApiService and maps DTOs to domain models.
//

import Foundation

final class AppointmentRepositoryImpl: AppointmentRepository {
    private let api: AppointmentApiService
        
    init(api: AppointmentApiService) {
        self.api = api
    }
    
    func getUserAppointments(page: Int, limit: Int) async throws -> PaginatedResponse<Appointment> {
        let dtoResponse = try await api.fetchUserAppointments(page: page, limit: limit)
        
        return try PaginatedResponse(dtoResponse) {
            try Appointment(dto: $0)
        }
    }
    
    func getAppointmentById(id: Int) async throws -> Appointment {
        let dto = try await api.getAppointmentById(id: id)
        return try Appointment(dto: dto)
    }
    
    func cancelAppointment(id: Int, request: AppointmentCancelRequest) async throws -> Appointment {
        let dto = try await api.cancelAppointment(id: id, request: request)
        return try Appointment(dto: dto)
    }
}
