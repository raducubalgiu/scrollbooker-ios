//
//  DeleteProductVariantUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

final class DeleteProductVariantUseCase {
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func callAsFunction(productId: Int, variantId: Int) async throws {
        try await repository.deleteProductVariant(productId: productId, variantId: variantId)
    }
}
