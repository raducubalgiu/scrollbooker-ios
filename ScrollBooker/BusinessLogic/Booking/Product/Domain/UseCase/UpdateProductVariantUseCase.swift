//
//  UpdateProductVariantUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

final class UpdateProductVariantUseCase {
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func callAsFunction(productId: Int, variantId: Int, request: ProductVariantCreateRequestDTO) async throws -> Product {
        try await repository.updateProductVariant(productId: productId, variantId: variantId, request: request)
    }
}
