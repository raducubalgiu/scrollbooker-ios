//
//  CreateOwnClientAppointmentUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

final class CreateOwnClientAppointmentUseCase {
    private let repository: AppointmentRepository

    init(repository: AppointmentRepository) {
        self.repository = repository
    }

    func callAsFunction(request: AppointmentOwnClientCreateRequestDTO) async throws {
        _ = try await repository.createOwnClientAppointment(request: request)
    }
}
