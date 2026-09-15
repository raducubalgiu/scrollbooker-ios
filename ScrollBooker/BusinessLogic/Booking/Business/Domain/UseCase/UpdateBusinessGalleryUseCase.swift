//
//  UpdateBusinessGalleryUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation

final class UpdateBusinessGalleryUseCase {
    private let repository: BusinessRepository

    init(repository: BusinessRepository) {
        self.repository = repository
    }

    func callAsFunction(businessId: Int, photos: [Data]) async throws -> NoContent {
        try await repository.updateBusinessGallery(businessId: businessId, photos: photos)
    }
}
