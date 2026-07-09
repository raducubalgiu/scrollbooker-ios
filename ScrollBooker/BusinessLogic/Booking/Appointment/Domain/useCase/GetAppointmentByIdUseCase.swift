//
//  GetAppointmentByIdUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

final class GetAppointmentByIdUseCase {
    private let repository: AppointmentRepository

    init(repository: AppointmentRepository) {
        self.repository = repository
    }

    func callAsFunction(id: Int) async throws -> Appointment {
        try await repository.getAppointmentById(id: id)
    }
}
