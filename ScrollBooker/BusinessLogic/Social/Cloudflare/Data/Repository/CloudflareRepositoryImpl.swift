//
//  CloudflareRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import Foundation

final class CloudflareRepositoryImpl: CloudflareRepository {
    private let api: CloudflareApiService
        
    init(api: CloudflareApiService) {
        self.api = api
    }
    
    func getUploadUrl(request: CloudflareDirectUploadRequest) async throws -> CloudflareDirectUpload {
        let dto = try await api.getUploadUrl(request: request)
        return try CloudflareDirectUpload(dto: dto)
    }
    
    func uploadVideo(
        uploadUrl: String,
        videoURL: URL,
        onProgress: @escaping @Sendable (Double) -> Void
    ) async throws -> NoContent {
        return try await api.uploadVideo(
            uploadUrl: uploadUrl,
            videoURL: videoURL,
            onProgress: onProgress
        )
    }
}
