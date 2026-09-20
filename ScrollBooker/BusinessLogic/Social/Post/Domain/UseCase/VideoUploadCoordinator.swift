//
//  VideoUploadCoordinator.swift
//  ScrollBooker
//

import Foundation
import AVFoundation

struct UploadedVideo {
    let provider: String
    let providerUid: String
}

/// Shared by CreateVideoPostUseCase and CreateVideoReviewUseCase — both need the same
/// duration-check + Cloudflare direct-upload steps before building their own (different)
/// request body.
final class VideoUploadCoordinator {
    private let cloudflareRepository: CloudflareRepository
    private let maxVideoDurationMs: Int64 = 60_000

    init(cloudflareRepository: CloudflareRepository) {
        self.cloudflareRepository = cloudflareRepository
    }

    func upload(videoURL: URL, onProgress: @Sendable @escaping (Double) -> Void) async throws -> UploadedVideo {
        let durationMs = try await getVideoDuration(from: videoURL)

        if durationMs > maxVideoDurationMs {
            throw NSError(
                domain: "VideoUploadCoordinator",
                code: 400,
                userInfo: [
                    NSLocalizedDescriptionKey: "The video exceeds the maximum allowed duration of 60 seconds."
                ]
            )
        }

        let directUpload = try await cloudflareRepository.getUploadUrl(
            request: CloudflareDirectUploadRequest()
        )

        _ = try await cloudflareRepository.uploadVideo(
            uploadUrl: directUpload.uploadUrl,
            videoURL: videoURL,
            onProgress: onProgress
        )

        return UploadedVideo(provider: "cloudflare_stream", providerUid: directUpload.providerUid)
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
