//
//  GetCloudflareUploadUrlUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import Foundation

final class GetCloudflareUploadUrlUseCase {
    private let repository: CloudflareRepository

    init(repository: CloudflareRepository) {
        self.repository = repository
    }

    func callAsFunction(request: CloudflareDirectUploadRequest) async throws -> CloudflareDirectUpload {
        try await repository.getUploadUrl(request: request)
    }
}
