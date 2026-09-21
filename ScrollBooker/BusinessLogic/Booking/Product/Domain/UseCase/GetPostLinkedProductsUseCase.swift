//
//  GetPostLinkedProductsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import Foundation

final class GetPostLinkedProductsUseCase {
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func callAsFunction(
        postId: Int,
        lat: Double? = nil,
        lng: Double? = nil
    ) async throws -> LinkedProducts {
        try await repository.getLinkedProductsByPostId(postId: postId, lat: lat, lng: lng)
    }
}
