//
//  ApppintmentRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

protocol AppointmentRepository: Sendable {
    func getUserAppointments(page: Int, limit: Int) async throws -> PaginatedResponse<Appointment>
    func getAppointmentById(id: Int) async throws -> Appointment
    func cancelAppointment(id: Int, request: AppointmentCancelRequest) async throws -> Appointment
    func createScrollBookerAppointment(request: AppointmentScrollBookerCreateRequest) async throws -> NoContent
}
