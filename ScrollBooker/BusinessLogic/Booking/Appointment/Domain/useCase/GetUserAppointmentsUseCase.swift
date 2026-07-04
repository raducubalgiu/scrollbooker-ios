//
//  GetUserAppointmentsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//
//  Use case that exposes appointments retrieval from repository. Keeps domain layer free of data details.
//

import Foundation

protocol GetUserAppointmentsUseCase: Sendable {
    func callAsFunction(page: Int, limit: Int) async throws -> PaginatedResponse<Appointment>
}

final class GetUserAppointmentsUseCaseImpl: GetUserAppointmentsUseCase {
    private let repository: AppointmentRepository
    
    init(repository: AppointmentRepository) {
        self.repository = repository
    }
    
    func callAsFunction(page: Int, limit: Int) async throws -> PaginatedResponse<Appointment> {
        return try await repository.getUserAppointments(page: page, limit: limit)
    }
}
