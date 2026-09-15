//
//  OnboardingRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

final class OnboardingRepositoryImpl: OnboardingRepository {
    private let api: OnboardingApiService

    init(api: OnboardingApiService) {
        self.api = api
    }

    func collectUserUsername(username: String) async throws -> AuthState {
        let dto = try await api.collectUserUsername(request: UpdateUsernameRequest(username: username))
        return AuthState(dto: dto)
    }

    func collectBusiness(
        description: String?,
        placeId: String,
        businessTypeId: Int,
        ownerFullName: String
    ) async throws -> BusinessCreateResponse {
        let request = BusinessCreateRequestDTO(
            description: description,
            placeId: placeId,
            businessTypeId: businessTypeId,
            ownerFullName: ownerFullName
        )
        let dto = try await api.collectBusiness(request: request)
        return BusinessCreateResponse(dto: dto)
    }
}
