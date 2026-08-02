//
//  CloudflareApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import Foundation

protocol CloudflareApiService: Sendable {
    func getUploadUrl(request: CloudflareDirectUploadRequest) async throws -> CloudflareDirectUploadDto
    func uploadVideo(
        uploadUrl: String,
        videoURL: URL,
        onProgress: @escaping @Sendable (Double) -> Void
    ) async throws -> NoContent
}

final class CloudflareAPIImpl: CloudflareApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getUploadUrl(request: CloudflareDirectUploadRequest) async throws -> CloudflareDirectUploadDto {
        return try await client.request(
            "cloudflare/upload",
            method: .post,
            body: request
        )
    }
    
    func uploadVideo(
        uploadUrl: String,
        videoURL: URL,
        onProgress: @escaping @Sendable (Double) -> Void
    ) async throws -> NoContent {
        let videoData = try Data(contentsOf: videoURL, options: .mappedIfSafe)
        
        let file = MultipartFile(
            name: "file",
            filename: "video.mp4",
            data: videoData,
            mimeType: "video/mp4"
        )
        
        return try await client.multiPartRequest(
            absoluteURLString: uploadUrl,
            method: .post,
            fields: [:],
            files: [file],
            onProgress: onProgress
        )
    }
}
