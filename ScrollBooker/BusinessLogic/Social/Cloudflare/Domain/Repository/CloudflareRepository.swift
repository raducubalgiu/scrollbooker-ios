//
//  CloudflareRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import Foundation

protocol CloudflareRepository: Sendable {
    func getUploadUrl(request: CloudflareDirectUploadRequest) async throws -> CloudflareDirectUpload
    
    func uploadVideo(
        uploadUrl: String,
        videoURL: URL,
        onProgress: @escaping @Sendable (Double) -> Void
    ) async throws -> NoContent
}
