//
//  GetProductByIdUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

final class GetProductByIdUseCase {
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func callAsFunction(productId: Int) async throws -> Product {
        try await repository.getProductById(productId: productId)
    }
}
