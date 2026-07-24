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

    func makeCommentsViewModel(postId: Int) -> CommentsViewModel {
        CommentsViewModel(
            postId: postId,
            getPostCommentsUseCase: getPostCommentsUseCase
        )
    }
}
