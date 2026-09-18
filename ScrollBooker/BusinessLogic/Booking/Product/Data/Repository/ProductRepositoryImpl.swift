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

    func createProduct(_ request: ProductCreateWithFiltersRequestDTO) async throws -> Product {
        let dto = try await api.createProduct(request)
        return Product(dto: dto)
    }

    func getProductById(productId: Int) async throws -> Product {
        let dto = try await api.getProductById(productId: productId)
        return Product(dto: dto)
    }

    func updateProductBaseInfo(productId: Int, request: ProductBaseInfoUpdateRequestDTO) async throws -> Product {
        let dto = try await api.updateProductBaseInfo(productId: productId, request: request)
        return Product(dto: dto)
    }

    func createProductVariant(productId: Int, request: ProductVariantCreateRequestDTO) async throws -> Product {
        let dto = try await api.createProductVariant(productId: productId, request: request)
        return Product(dto: dto)
    }

    func updateProductVariant(productId: Int, variantId: Int, request: ProductVariantCreateRequestDTO) async throws -> Product {
        let dto = try await api.updateProductVariant(productId: productId, variantId: variantId, request: request)
        return Product(dto: dto)
    }

    func deleteProductVariant(productId: Int, variantId: Int) async throws {
        try await api.deleteProductVariant(productId: productId, variantId: variantId)
    }
}
