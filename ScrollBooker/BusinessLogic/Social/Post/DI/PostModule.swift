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
    
    private lazy var likePostUseCase: LikePostUseCase = {
        LikePostUseCase(repository: repository)
    }()
    
    private lazy var unlikePostUseCase: UnlikePostUseCase = {
        UnlikePostUseCase(repository: repository)
    }()
    
    private lazy var bookmarkPostUseCase: BookmarkPostUseCase = {
        BookmarkPostUseCase(repository: repository)
    }()
    
    private lazy var unbookmarkPostUseCase: UnbookmarkPostUseCase = {
        UnbookmarkPostUseCase(repository: repository)
    }()
    
    lazy var getVideoReviewsUseCase: GetVideoReviewsUseCase = {
        GetVideoReviewsUseCase(repository: repository)
    }()
    
    lazy var getUserPostsUseCase: GetUserPostsUseCase = {
        GetUserPostsUseCase(repository: repository)
    }()

    func makeExploreTabViewModel() -> ExploreTabViewModel {
        ExploreTabViewModel(
            getExplorePostsUseCase: getExplorePostsUseCase,
            likePostUseCase: likePostUseCase,
            unlikePostUseCase: unlikePostUseCase,
            bookmarkPostUseCase: bookmarkPostUseCase,
            unbookmarkPostUseCase: unbookmarkPostUseCase
        )
    }
    
    func makeFollowingTabViewModel() -> FollowingTabViewModel {
        FollowingTabViewModel(
            getFollowingPostsUseCase: getFollowingPostsUseCase,
            likePostUseCase: likePostUseCase,
            unlikePostUseCase: unlikePostUseCase,
            bookmarkPostUseCase: bookmarkPostUseCase,
            unbookmarkPostUseCase: unbookmarkPostUseCase
        )
    }
    
    func makeFeedViewModel() -> FeedViewModel {
        FeedViewModel(
            exploreViewModel: makeExploreTabViewModel(),
            followingViewModel: makeFollowingTabViewModel()
        )
    }
}
