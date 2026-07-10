//
//  UserProfileModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import Foundation

@MainActor
final class UserProfileModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: UserProfileApiService = {
        UserProfileApiImpl(client: apiClient)
    }()

    private lazy var repository: UserProfileRepository = {
        UserProfileRepositoryImpl(api: apiService)
    }()

    private lazy var getUserProfile: GetUserProfileUseCase = {
        GetUserProfileUseCase(repository: repository)
    }()
    
    func makeProfileViewModel(username: String) -> ProfileViewModel {
        ProfileViewModel(
            username: username,
            getUserProfile: getUserProfile
        )
    }
}
