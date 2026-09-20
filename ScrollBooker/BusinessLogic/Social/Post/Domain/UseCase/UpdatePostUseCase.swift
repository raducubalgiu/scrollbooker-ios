//
//  UpdatePostUseCase.swift
//  ScrollBooker
//

final class UpdatePostUseCase {
    private let postsRepository: PostRepository

    init(postsRepository: PostRepository) {
        self.postsRepository = postsRepository
    }

    func callAsFunction(
        postId: Int,
        description: String?,
        linkedProductIds: [Int]?,
        serviceDomainId: Int?,
        customCover: String?
    ) async throws -> Post {
        let request = UpdatePostRequest(
            description: description,
            linkedProductIds: linkedProductIds,
            customCover: customCover,
            serviceDomainId: serviceDomainId
        )

        return try await postsRepository.updatePost(id: postId, request: request)
    }
}
