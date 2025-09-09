//
//  OnBoardingAPI.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.09.2025.
//

protocol OnboardingAPI {
    func searchUsername(username: String, token: String) async throws -> SearchUsername
    func collectUsername(username: String, token: String) async throws -> AuthState
}

final class OnboardingAPIImpl: OnboardingAPI {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func searchUsername(username: String, token: String) async throws -> SearchUsername {
        let dto: SearchUsernameDTO = try await client.request(
            "/users/available-username",
            method: .get,
            bearer: token,
            query: ["username": username]
        )
        return SearchUsername(dto: dto)
    }
    
    func collectUsername(username: String, token: String) async throws -> AuthState {
        let dto: AuthStateDTO = try await client.request(
            "/onboarding/collect-user-username/",
            method: .patch,
            bearer: token,
            body: CollectUsernameRequestDTO(username: username)
        )
        return AuthState(dto: dto)
    }
}
