//
//  DashboardRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

protocol DashboardRepository: Sendable {
    func getDashboardBooking(
        startDate: String,
        endDate: String
    ) async throws -> DashboardBooking
}
