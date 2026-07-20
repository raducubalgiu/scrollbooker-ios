//
//  BookingFlowRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import Foundation

protocol BookingFlowRepository: Sendable {
    func getBookingFlow(businessId: Int, employeeId: Int?) async throws -> BookingFlow
}
