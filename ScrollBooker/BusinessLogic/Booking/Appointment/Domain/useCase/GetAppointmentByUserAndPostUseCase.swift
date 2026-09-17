//
//  GetAppointmentByUserAndPostUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.09.2026.
//

final class GetAppointmentByUserAndPostUseCase {
    private let repository: AppointmentRepository

    init(repository: AppointmentRepository) {
        self.repository = repository
    }

    func callAsFunction(userId: Int, postId: Int) async throws -> Appointment {
        try await repository.getAppointmentByUserAndPost(userId: userId, postId: postId)
    }
}
