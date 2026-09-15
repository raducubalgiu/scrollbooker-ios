//
//  CollectBusinessGalleryUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation

final class CollectBusinessGalleryUseCase {
    private let repository: OnboardingRepository

    init(repository: OnboardingRepository) {
        self.repository = repository
    }

    func callAsFunction(businessId: Int, photos: [Data], skipUpdateGallery: Bool) async throws -> AuthState {
        try await repository.collectBusinessGallery(
            businessId: businessId,
            photos: photos,
            skipUpdateGallery: skipUpdateGallery
        )
    }
}
