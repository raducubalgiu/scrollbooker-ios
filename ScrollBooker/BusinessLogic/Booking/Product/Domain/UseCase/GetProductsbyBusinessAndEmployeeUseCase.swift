//
//  GetProductsbyBusinessAndEmployeeUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.07.2026.
//

import Foundation

final class GetProductsbyBusinessAndEmployeeUseCase {
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func callAsFunction(
        businessId: Int,
        employeeId: Int?,
        onlyServicesWithProducts: Bool,
        productsLimitPerService: Int?
    ) async throws -> UserProducts {
        try await repository.getProductsByBusinessAndEmployee(
            businessId: businessId,
            employeeId: employeeId,
            onlyServicesWithProducts: onlyServicesWithProducts,
            productsLimitPerService: productsLimitPerService
        )
    }
}
