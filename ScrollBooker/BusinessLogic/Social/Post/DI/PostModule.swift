//
//  PostModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.07.2026.
//

import Foundation

@MainActor
final class PostModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: PostApiService = {
        PostAPIImpl(client: apiClient)
    }()

    private lazy var repository: PostRepository = {
        PostRepositoryImpl(api: apiService)
    }()

    private lazy var getExplorePostsUseCase: GetExplorePostsUseCase = {
        GetExplorePostsUseCase(repository: repository)
    }()
    
    private lazy var getFollowingPostsUseCase: GetFollowingPostsUseCase = {
        GetFollowingPostsUseCase(repository: repository)
    }()

    func makeExploreTabViewModel() -> ExploreTabViewModel {
        ExploreTabViewModel(getExplorePostsUseCase: getExplorePostsUseCase)
    }
    
    func makeFollowingTabViewModel() -> FollowingTabViewModel {
        FollowingTabViewModel(getFollowingPostsUseCase: getFollowingPostsUseCase)
    }
    
    func makeFeedViewModel() -> FeedViewModel {
        FeedViewModel(
            exploreViewModel: makeExploreTabViewModel(),
            followingViewModel: makeFollowingTabViewModel()
        )
    }
}
