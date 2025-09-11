//
//  OnBoardingAPI.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.09.2025.
//

protocol OnboardingAPI {
    func searchUsername(username: String, token: String) async throws -> SearchUsername
    func collectUsername(username: String, token: String) async throws -> AuthState
    func collectBirthdate(birthdate: String?, token: String) async throws -> AuthState
    func collectGender(gender: String, token: String) async throws -> AuthState
    func collectLocationPermission(token: String) async throws -> AuthState
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
            "/onboarding/collect-user-username",
            method: .patch,
            bearer: token,
            body: UpdateUsernameRequestDTO(username: username)
        )
        return AuthState(dto: dto)
    }
    
    func collectBirthdate(birthdate: String?, token: String) async throws -> AuthState {
        let dto: AuthStateDTO = try await client.request(
            "/onboarding/collect-client-birthdate",
            method: .patch,
            bearer: token,
            body: UpdateBirthdateRequestDTO(birthdate: birthdate)
        )
        return AuthState(dto: dto)
    }
    
    func collectGender(gender: String, token: String) async throws -> AuthState {
        let dto: AuthStateDTO = try await client.request(
            "/onboarding/collect-client-gender",
            method: .patch,
            bearer: token,
            body: UpdateGenderRequestDTO(gender: gender)
        )
        return AuthState(dto: dto)
    }
    
    func collectLocationPermission(token: String) async throws -> AuthState {
        let dto: AuthStateDTO = try await client.request(
            "/onboarding/collect-user-location-permission",
            method: .patch,
            bearer: token
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
