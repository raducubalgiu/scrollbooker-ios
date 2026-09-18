//
//  CreateProductVariantUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

final class CreateProductVariantUseCase {
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func callAsFunction(productId: Int, request: ProductVariantCreateRequestDTO) async throws -> Product {
        try await repository.createProductVariant(productId: productId, request: request)
    }
}
