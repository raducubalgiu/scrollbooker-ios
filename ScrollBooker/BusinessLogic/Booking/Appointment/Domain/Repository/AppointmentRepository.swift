//
//  ApppintmentRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

protocol AppointmentRepository: Sendable {
    func getUserAppointments(page: Int, limit: Int) async throws -> PaginatedResponse<Appointment>
}
