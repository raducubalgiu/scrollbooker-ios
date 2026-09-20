//
//  CreateVideoReviewUseCase.swift
//  ScrollBooker
//

import Foundation

final class CreateVideoReviewUseCase {
    private let uploader: VideoUploadCoordinator
    private let postsRepository: PostRepository

    init(cloudflareRepository: CloudflareRepository, postsRepository: PostRepository) {
        self.uploader = VideoUploadCoordinator(cloudflareRepository: cloudflareRepository)
        self.postsRepository = postsRepository
    }

    func callAsFunction(
        videoURL: URL,
        appointmentId: Int,
        businessOrEmployeeId: Int,
        rating: Int,
        review: String?,
        description: String?,
        customCover: String?,
        onProgress: @Sendable @escaping (Double) -> Void
    ) async throws -> NoContent {
        let uploaded = try await uploader.upload(videoURL: videoURL, onProgress: onProgress)

        let request = CreateVideoReviewRequest(
            businessOrEmployeeId: businessOrEmployeeId,
            appointmentId: appointmentId,
            review: review,
            rating: rating,
            description: description,
            provider: uploaded.provider,
            providerUid: uploaded.providerUid,
            orderIndex: 0,
            customCover: customCover
        )

        return try await postsRepository.createVideoReview(request: request)
    }
}
