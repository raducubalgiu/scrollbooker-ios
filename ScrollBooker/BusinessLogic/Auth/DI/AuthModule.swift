//
//  AuthModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

@MainActor
final class AuthModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: AuthApiService = {
        AuthAPIImpl(client: apiClient)
    }()

    lazy var repository: AuthRepository = {
        AuthRepositoryImpl(api: apiService)
    }()

    lazy var loginUseCase: LoginUseCase = {
        LoginUseCase(repository: repository)
    }()

    lazy var registerUseCase: RegisterUseCase = {
        RegisterUseCase(repository: repository)
    }()

    lazy var refreshSessionUseCase: RefreshSessionUseCase = {
        RefreshSessionUseCase(repository: repository)
    }()

    lazy var verifyEmailUseCase: VerifyEmailUseCase = {
        VerifyEmailUseCase(repository: repository)
    }()
}
