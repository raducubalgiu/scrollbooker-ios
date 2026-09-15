//
//  GetUserAppointmentsNumberUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

final class GetUserAppointmentsNumberUseCase {
    private let repository: AppointmentRepository

    init(repository: AppointmentRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws -> Int {
        try await repository.getUserAppointmentsNumber()
    }
}
