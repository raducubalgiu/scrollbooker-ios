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
    private let store: AuthStore
    private let getUserInfoUseCase: GetUserInfoUseCase
    private let getUserPermissionsUseCase: GetUserPermissionsUseCase

    init(
        apiClient: APIClient,
        store: AuthStore,
        getUserInfoUseCase: GetUserInfoUseCase,
        getUserPermissionsUseCase: GetUserPermissionsUseCase
    ) {
        self.apiClient = apiClient
        self.store = store
        self.getUserInfoUseCase = getUserInfoUseCase
        self.getUserPermissionsUseCase = getUserPermissionsUseCase
    }

    private lazy var apiService: AuthApiService = {
        AuthAPIImpl(client: apiClient)
    }()

    lazy var repository: AuthRepository = {
        AuthRepositoryImpl(api: apiService)
    }()
    
    lazy var signInWithGoogleUseCase: SignInWithGoogleUseCase = {
        SignInWithGoogleUseCase(repository: repository)
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

    lazy var saveSessionUseCase: SaveSessionUseCase = {
        SaveSessionUseCase(
            store: store,
            getUserInfoUseCase: getUserInfoUseCase,
            getUserPermissionsUseCase: getUserPermissionsUseCase
        )
    }()

    lazy var isLoggedInUseCase: IsLoggedInUseCase = {
        IsLoggedInUseCase(
            store: store,
            getUserInfoUseCase: getUserInfoUseCase,
            getUserPermissionsUseCase: getUserPermissionsUseCase,
            refreshSessionUseCase: refreshSessionUseCase
        )
    }()

    func makeAuthViewModel(session: SessionManager) -> AuthViewModel {
        AuthViewModel(
            session: session,
            signInWithGoogleUseCase: signInWithGoogleUseCase,
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
            verifyEmailUseCase: verifyEmailUseCase,
            saveSessionUseCase: saveSessionUseCase
        )
    }
}
