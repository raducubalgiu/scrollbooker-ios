//
//  EmploymentRequestRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

protocol EmploymentRequestRepository: Sendable {
    func getUserEmploymentRequests(userId: Int) async throws -> [EmploymentRequest]
}
