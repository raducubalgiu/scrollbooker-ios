//
//  CreateVideoPostUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import Foundation

final class CreateVideoPostUseCase {
    private let uploader: VideoUploadCoordinator
    private let postsRepository: PostRepository

    init(cloudflareRepository: CloudflareRepository, postsRepository: PostRepository) {
        self.uploader = VideoUploadCoordinator(cloudflareRepository: cloudflareRepository)
        self.postsRepository = postsRepository
    }

    func callAsFunction(
        videoURL: URL,
        description: String?,
        linkedProductIds: [Int],
        serviceDomainId: Int?,
        targetGender: GenderTypeEnum,
        customCover: String?,
        onProgress: @Sendable @escaping (Double) -> Void
    ) async throws -> NoContent {
        let uploaded = try await uploader.upload(videoURL: videoURL, onProgress: onProgress)

        let createPostRequest = CreatePostRequest(
            description: description,
            provider: uploaded.provider,
            providerUid: uploaded.providerUid,
            orderIndex: 0,
            linkedProductIds: linkedProductIds,
            customCover: customCover,
            serviceDomainId: serviceDomainId,
            targetGender: targetGender.rawValue
        )

        return try await postsRepository.createPost(request: createPostRequest)
    }
}
