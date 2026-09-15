//
//  OnboardingApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

protocol OnboardingApiService: Sendable {
    func collectUserUsername(request: UpdateUsernameRequest) async throws -> AuthStateDTO
    func collectBusiness(request: BusinessCreateRequestDTO) async throws -> BusinessCreateResponseDTO
}

final class OnboardingAPIImpl: OnboardingApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func collectUserUsername(request: UpdateUsernameRequest) async throws -> AuthStateDTO {
        try await client.request(
            "onboarding/collect-user-username",
            method: .patch,
            body: request
        )
    }

    func collectBusiness(request: BusinessCreateRequestDTO) async throws -> BusinessCreateResponseDTO {
        try await client.request(
            "onboarding/collect-business",
            method: .post,
            body: request
        )
    }
}
