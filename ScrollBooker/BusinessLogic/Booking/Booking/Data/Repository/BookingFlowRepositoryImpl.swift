//
//  BookingFlowRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import Foundation

final class BookingFlowRepositoryImpl: BookingFlowRepository {
    private let api: BookingFlowApiService
        
    init(api: BookingFlowApiService) {
        self.api = api
    }
    
    func getBookingFlow(businessId: Int, employeeId: Int?) async throws -> BookingFlow {
        let dtoResponse = try await api.getBookingFlow(businessId: businessId, employeeId: employeeId)
        return BookingFlow(dto: dtoResponse)
    }
}
