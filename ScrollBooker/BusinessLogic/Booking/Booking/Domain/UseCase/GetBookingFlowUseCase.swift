//
//  GetBookingFlowUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import Foundation

final class GetBookingFlowUseCase {
    private let repository: BookingFlowRepository

    init(repository: BookingFlowRepository) {
        self.repository = repository
    }

    func callAsFunction(businessId: Int, employeeId: Int?) async throws -> BookingFlow {
        try await repository.getBookingFlow(businessId: businessId, employeeId: employeeId)
    }
}
