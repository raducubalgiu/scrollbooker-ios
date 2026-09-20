//
//  DeleteReviewUseCase.swift
//  ScrollBooker
//

final class DeleteReviewUseCase {
    private let repository: ReviewRepository

    init(repository: ReviewRepository) {
        self.repository = repository
    }

    func callAsFunction(id: Int) async throws -> NoContent {
        return try await repository.deleteReview(id: id)
    }
}
