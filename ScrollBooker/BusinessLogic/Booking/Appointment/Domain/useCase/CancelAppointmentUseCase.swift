//
//  CancelAppointmentUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

final class CancelAppointmentUseCase {
    private let repository: AppointmentRepository

    init(repository: AppointmentRepository) {
        self.repository = repository
    }

    func callAsFunction(
        id: Int,
        canceledReason: String,
        canceledByUserId: Int
    ) async throws -> Appointment {
        let request = AppointmentCancelRequest(
            canceled_reason: canceledReason,
            canceled_by_user_id: canceledByUserId
        )
        return try await repository.cancelAppointment(id: id, request: request)
    }
}
