//
//  CollectBusinessUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

final class CollectBusinessUseCase {
    private let repository: OnboardingRepository

    init(repository: OnboardingRepository) {
        self.repository = repository
    }

    func callAsFunction(
        description: String?,
        placeId: String,
        businessTypeId: Int,
        ownerFullName: String
    ) async throws -> BusinessCreateResponse {
        try await repository.collectBusiness(
            description: description,
            placeId: placeId,
            businessTypeId: businessTypeId,
            ownerFullName: ownerFullName
        )
    }
}
