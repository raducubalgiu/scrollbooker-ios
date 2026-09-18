//
//  ProductApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.07.2026.
//

import Foundation

protocol ProductApiService: Sendable {
    func getProductsByBusinessAndEmployee(
        businessId: Int,
        employeeId: Int?,
        onlyServicesWithProducts: Bool,
        productsLimitPerService: Int?
    ) async throws -> UserProductsDto
    
    func getLinkedProductsByPostId(postId: Int) async throws -> [ProductDto]

    func createProduct(_ request: ProductCreateWithFiltersRequestDTO) async throws -> ProductDto

    func getProductById(productId: Int) async throws -> ProductDto

    func updateProductBaseInfo(productId: Int, request: ProductBaseInfoUpdateRequestDTO) async throws -> ProductDto

    func createProductVariant(productId: Int, request: ProductVariantCreateRequestDTO) async throws -> ProductDto

    func updateProductVariant(productId: Int, variantId: Int, request: ProductVariantCreateRequestDTO) async throws -> ProductDto

    func deleteProductVariant(productId: Int, variantId: Int) async throws
}

final class ProductAPIImpl: ProductApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getProductsByBusinessAndEmployee(
        businessId: Int,
        employeeId: Int?,
        onlyServicesWithProducts: Bool,
        productsLimitPerService: Int?
    ) async throws -> UserProductsDto {
        var queryParameters: [String: String] = [
            "only_services_with_products": String(onlyServicesWithProducts)
        ]
        
        if let employeeId = employeeId {
            queryParameters["employee_id"] = String(employeeId)
        }
        
        if let limit = productsLimitPerService {
            queryParameters["products_limit_per_service"] = String(limit)
        }
        
        return try await client.request(
            "businesses/\(businessId)/products",
            method: .get,
            query: queryParameters
        )
    }
    
    func getLinkedProductsByPostId(postId: Int) async throws -> [ProductDto] {
        return try await client.request(
            "posts/\(postId)/products",
            method: .get
        )
    }

    func createProduct(_ request: ProductCreateWithFiltersRequestDTO) async throws -> ProductDto {
        return try await client.request(
            "products",
            method: .post,
            body: request
        )
    }

    func getProductById(productId: Int) async throws -> ProductDto {
        return try await client.request(
            "products/\(productId)",
            method: .get
        )
    }

    func updateProductBaseInfo(productId: Int, request: ProductBaseInfoUpdateRequestDTO) async throws -> ProductDto {
        return try await client.request(
            "products/\(productId)/update-base-info",
            method: .put,
            body: request
        )
    }

    func createProductVariant(productId: Int, request: ProductVariantCreateRequestDTO) async throws -> ProductDto {
        return try await client.request(
            "products/\(productId)/variants",
            method: .post,
            body: request
        )
    }

    func updateProductVariant(productId: Int, variantId: Int, request: ProductVariantCreateRequestDTO) async throws -> ProductDto {
        return try await client.request(
            "products/\(productId)/variants/\(variantId)",
            method: .put,
            body: request
        )
    }

    func deleteProductVariant(productId: Int, variantId: Int) async throws {
        let _: NoContent = try await client.request(
            "products/\(productId)/variants/\(variantId)",
            method: .delete
        )
    }
}
