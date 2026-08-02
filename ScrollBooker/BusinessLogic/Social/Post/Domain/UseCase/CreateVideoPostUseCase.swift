//
//  CreateVideoPostUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import Foundation
import AVFoundation

final class CreateVideoPostUseCase {
    private let cloudflareRepository: CloudflareRepository
    private let postsRepository: PostRepository
    
    private let maxVideoDurationMs: Int64 = 60_000

    init(cloudflareRepository: CloudflareRepository, postsRepository: PostRepository) {
        self.cloudflareRepository = cloudflareRepository
        self.postsRepository = postsRepository
    }

    func callAsFunction(
        videoURL: URL,
        description: String?,
        linkedProductIds: [Int],
        businessOrEmployeeId: Int?,
        isVideoReview: Bool,
        videoReviewMessage: String?,
        rating: Int?,
        onProgress: @Sendable @escaping (Double) -> Void
    ) async throws -> NoContent {
        let durationMs = try await getVideoDuration(from: videoURL)
        
        if durationMs > maxVideoDurationMs {
            throw NSError(
                domain: "CreateVideoPostUseCase",
                code: 400,
                userInfo: [
                    NSLocalizedDescriptionKey: "The video exceeds the maximum allowed duration of 60 seconds."
                ]
            )
        }

        // 2. Cerem URL-ul de upload direct de la Cloudflare
        let directUpload = try await cloudflareRepository.getUploadUrl(
            request: CloudflareDirectUploadRequest()
        )
        
        // 3. Încărcăm fișierul binar pe Cloudflare Stream cu urmărirea progresului
        _ = try await cloudflareRepository.uploadVideo(
            uploadUrl: directUpload.uploadUrl,
            videoURL: videoURL,
            onProgress: onProgress
        )

        // 4. Salvăm înregistrarea finală în baza de date proprie prin API
        let createPostRequest = CreatePostRequest(
            description: description,
            provider: "cloudflare_stream",
            providerUid: directUpload.providerUid,
            orderIndex: 0,
            linkedProductIds: linkedProductIds,
            videoReviewMessage: videoReviewMessage,
            isVideoReview: isVideoReview,
            rating: rating,
            businessOrEmployeeId: businessOrEmployeeId
        )
        
        return try await postsRepository.createPost(request: createPostRequest)
    }

    private func getVideoDuration(from url: URL) async throws -> Int64 {
        let asset = AVURLAsset(url: url)
        do {
            let duration = try await asset.load(.duration)
            let seconds = CMTimeGetSeconds(duration)
            
            guard !seconds.isNaN && !seconds.isInfinite else { return 0 }
            return Int64(seconds * 1000)
        } catch {
            return 0
        }
    }
}
