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
    
    private lazy var followUserUseCase: FollowUserUseCase = {
        FollowUserUseCase(repository: repository)
    }()
    
    private lazy var unfollowUserUseCase: UnfollowUserUseCase = {
        UnfollowUserUseCase(repository: repository)
    }()
    
    func makeSocialViewModel(userId: Int) -> SocialViewModel {
        SocialViewModel(
            userId: userId,
            getUserFollowersUseCase: getUserFollowersUseCase,
            getUserFollowingsUseCase: getUserFollowingsUseCase,
            followUserUseCase: followUserUseCase,
            unfollowUserUseCase: unfollowUserUseCase
        )
    }
}
