//
//  CreateBlockAppointmentsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

final class CreateBlockAppointmentsUseCase {
    private let repository: AppointmentRepository

    init(repository: AppointmentRepository) {
        self.repository = repository
    }

    func callAsFunction(request: AppointmentBlockRequestDTO) async throws {
        _ = try await repository.createBlockAppointments(request: request)
    }
}
