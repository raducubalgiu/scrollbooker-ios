//
//  OnBoardingAPI.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.09.2025.
//

import Foundation

// MARK: - Protocol
/// Protocol marcat ca Sendable pentru conformarea strictă la modelul de concurență din Swift 6.
protocol OnboardingAPI: Sendable {
    func searchUsername(username: String) async throws -> SearchUsername
    func collectUsername(username: String) async throws -> AuthState
    func collectBirthdate(birthdate: String?) async throws -> AuthState
    func collectGender(gender: String) async throws -> AuthState
    func collectLocationPermission() async throws -> AuthState
}

// MARK: - Implementare
final class OnboardingAPIImpl: OnboardingAPI {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func searchUsername(username: String) async throws -> SearchUsername {
        // Am eliminat argumentul `bearer: token` și caracterul `/` de la începutul rutei
        let dto: SearchUsernameDTO = try await client.request(
            "users/available-username",
            method: .get,
            query: ["username": username]
        )
        return SearchUsername(dto: dto)
    }
    
    func collectUsername(username: String) async throws -> AuthState {
        let dto: AuthStateDTO = try await client.request(
            "onboarding/collect-user-username",
            method: .patch,
            body: UpdateUsernameRequestDTO(username: username)
        )
        return AuthState(dto: dto)
    }
    
    func collectBirthdate(birthdate: String?) async throws -> AuthState {
        let dto: AuthStateDTO = try await client.request(
            "onboarding/collect-client-birthdate",
            method: .patch,
            body: UpdateBirthdateRequestDTO(birthdate: birthdate)
        )
        return AuthState(dto: dto)
    }
    
    func collectGender(gender: String) async throws -> AuthState {
        let dto: AuthStateDTO = try await client.request(
            "onboarding/collect-client-gender",
            method: .patch,
            body: UpdateGenderRequestDTO(gender: gender)
        )
        return AuthState(dto: dto)
    }
    
    func collectLocationPermission() async throws -> AuthState {
        let dto: AuthStateDTO = try await client.request(
            "onboarding/collect-user-location-permission",
            method: .patch
        )
        return AuthState(dto: dto)
    }
}
//
//final class DummyOnboardingAPI: OnboardingAPI {
//    func searchUsername(username: String, token: String) async throws -> SearchUsername {
//        return SearchUsername(dto: SearchUsernameDTO(
//            available: true,
//            suggestions: [],
//            username: "")
//        )
//    }
//    
//    func collectUsername(username: String, token: String) async throws -> AuthState {
//        return AuthState(isValidated: false, registrationStep: .collectUserUsername)
//    }
//    
//    func collectGender(gender: String, token: String) async throws -> AuthState {
//        return AuthState(isValidated: false, registrationStep: .collectClientGender)
//    }
//    
//    func collectBirthdate(birthdate: String?, token: String) async throws -> AuthState {
//        return AuthState(isValidated: false, registrationStep: .collectClientBirthdate)
//    }
//}
