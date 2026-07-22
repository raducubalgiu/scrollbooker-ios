//
//  CreateScrollBookerAppointmentUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

final class CreateScrollBookerAppointmentUseCase {
    private let repository: AppointmentRepository

    init(repository: AppointmentRepository) {
        self.repository = repository
    }

    func callAsFunction(request: AppointmentScrollBookerCreateRequest) async throws -> NoContent {
        return try await repository.createScrollBookerAppointment(request: request)
    }
}
