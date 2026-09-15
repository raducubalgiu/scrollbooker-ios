//
//  OnboardingRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

protocol OnboardingRepository: Sendable {
    func collectUserUsername(username: String) async throws -> AuthState
    func collectBusiness(
        description: String?,
        placeId: String,
        businessTypeId: Int,
        ownerFullName: String
    ) async throws -> BusinessCreateResponse
    func collectBusinessGallery(businessId: Int, photos: [Data], skipUpdateGallery: Bool) async throws -> AuthState
    func collectBusinessServices(serviceIds: [Int]) async throws -> AuthState
}
