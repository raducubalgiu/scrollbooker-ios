//
//  FollowModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import Foundation

@MainActor
final class FollowModule {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: FollowApiService = {
        FollowAPIImpl(client: apiClient)
    }()

    private lazy var repository: FollowRepository = {
        FollowRepositoryImpl(api: apiService)
    }()

    private lazy var getUserFollowersUseCase: GetUserFollowersUseCase = {
        GetUserFollowersUseCase(repository: repository)
    }()
    
    private lazy var getUserFollowingsUseCase: GetUserFollowingsUseCase = {
        GetUserFollowingsUseCase(repository: repository)
    }()
    
    func makeSocialViewModel(userId: Int) -> SocialViewModel {
        SocialViewModel(
            userId: userId,
            getUserFollowers: getUserFollowersUseCase,
            getUserFollowings: getUserFollowingsUseCase
        )
    }
}
