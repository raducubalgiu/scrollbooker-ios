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
    ) async throws -> [Product] {
        try await repository.getLinkedProductsByPostId(postId: postId)
    }
}
