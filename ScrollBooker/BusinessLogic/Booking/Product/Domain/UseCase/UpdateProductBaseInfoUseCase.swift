//
//  UpdateProductBaseInfoUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

final class UpdateProductBaseInfoUseCase {
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func callAsFunction(productId: Int, request: ProductBaseInfoUpdateRequestDTO) async throws -> Product {
        try await repository.updateProductBaseInfo(productId: productId, request: request)
    }
}
