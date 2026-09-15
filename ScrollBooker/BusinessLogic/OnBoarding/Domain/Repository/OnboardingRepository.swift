//
//  OnboardingRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

protocol OnboardingRepository: Sendable {
    func collectUserUsername(username: String) async throws -> AuthState
    func collectBusiness(
        description: String?,
        placeId: String,
        businessTypeId: Int,
        ownerFullName: String
    ) async throws -> BusinessCreateResponse
}
