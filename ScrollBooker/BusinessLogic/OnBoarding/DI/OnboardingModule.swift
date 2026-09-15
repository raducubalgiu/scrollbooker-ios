//
//  OnboardingModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

@MainActor
final class OnboardingModule {
    private let apiClient: APIClient
    private let getUserInfoUseCase: GetUserInfoUseCase
    private let searchUsernameUseCase: SearchUsernameUseCase

    init(
        apiClient: APIClient,
        getUserInfoUseCase: GetUserInfoUseCase,
        searchUsernameUseCase: SearchUsernameUseCase
    ) {
        self.apiClient = apiClient
        self.getUserInfoUseCase = getUserInfoUseCase
        self.searchUsernameUseCase = searchUsernameUseCase
    }

    private lazy var apiService: OnboardingApiService = {
        OnboardingAPIImpl(client: apiClient)
    }()

    private lazy var repository: OnboardingRepository = {
        OnboardingRepositoryImpl(api: apiService)
    }()

    lazy var collectUserUsernameUseCase: CollectUserUsernameUseCase = {
        CollectUserUsernameUseCase(repository: repository)
    }()

    func makeCollectUsernameViewModel(session: SessionManager) -> CollectUsernameViewModel {
        CollectUsernameViewModel(
            session: session,
            collectUserUsernameUseCase: collectUserUsernameUseCase,
            searchUsernameUseCase: searchUsernameUseCase,
            getUserInfoUseCase: getUserInfoUseCase
        )
    }
}
