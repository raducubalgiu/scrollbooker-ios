//
//  ProductRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.07.2026.
//

import Foundation

final class ProductRepositoryImpl: ProductRepository {
    private let api: ProductApiService
        
    init(api: ProductApiService) {
        self.api = api
    }
    
    func getProductsByBusinessAndEmployee(
        businessId: Int,
        employeeId: Int?,
        onlyServicesWithProducts: Bool,
        productsLimitPerService: Int?
    ) async throws -> UserProducts {
        let dtoResponse = try await api.getProductsByBusinessAndEmployee(
            businessId: businessId,
            employeeId: employeeId,
            onlyServicesWithProducts: onlyServicesWithProducts,
            productsLimitPerService: productsLimitPerService
        )
        
        return UserProducts(dto: dtoResponse)
    }
    
    func getLinkedProductsByPostId(postId: Int) async throws -> [Product] {
        let responseDto = try await api.getLinkedProductsByPostId(postId: postId)
        
        return responseDto.map { Product(dto: $0) }
    }
    
}
