//
//  CreateProductUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

final class CreateProductUseCase {
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func callAsFunction(_ request: ProductCreateWithFiltersRequestDTO) async throws -> Product {
        try await repository.createProduct(request)
    }
}
