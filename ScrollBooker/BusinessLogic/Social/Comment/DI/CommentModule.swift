//
//  CommentModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

@MainActor
final class CommentModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: CommentApiService = {
        CommentAPIImpl(client: apiClient)
    }()

    private lazy var repository: CommentRepository = {
        CommentRepositoryImpl(api: apiService)
    }()

    private lazy var getPostCommentsUseCase: GetPostCommentsUseCase = {
        GetPostCommentsUseCase(repository: repository)
    }()
    
    private lazy var getCommentRepliesUseCase: GetCommentRepliesUseCase = {
        GetCommentRepliesUseCase(repository: repository)
    }()
    
    private lazy var createCommentUseCase: CreateCommentUseCase = {
        CreateCommentUseCase(repository: repository)
    }()
    
    private lazy var likeCommentUseCase: LikeCommentUseCase = {
        LikeCommentUseCase(repository: repository)
    }()
    
    private lazy var unlikeCommentUseCase: UnlikeCommentUseCase = {
        UnlikeCommentUseCase(repository: repository)
    }()

    func makeCommentsViewModel(postId: Int) -> CommentsViewModel {
        CommentsViewModel(
            postId: postId,
            getPostCommentsUseCase: getPostCommentsUseCase,
            createCommentUseCase: createCommentUseCase,
            likeCommentUseCase: likeCommentUseCase,
            unlikeCommentUseCase: unlikeCommentUseCase,
            getCommentRepliesUseCase: getCommentRepliesUseCase
        )
    }
}
