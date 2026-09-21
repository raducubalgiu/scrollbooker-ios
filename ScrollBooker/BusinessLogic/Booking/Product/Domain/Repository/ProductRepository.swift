//
//  ProductRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.07.2026.
//

protocol ProductRepository: Sendable {
    func getProductsByBusinessAndEmployee(
        businessId: Int,
        employeeId: Int?,
        onlyServicesWithProducts: Bool,
        productsLimitPerService: Int?
    ) async throws -> UserProducts
    
    func getLinkedProductsByPostId(postId: Int, lat: Double?, lng: Double?) async throws -> LinkedProducts

    func createProduct(_ request: ProductCreateWithFiltersRequestDTO) async throws -> Product

    func getProductById(productId: Int) async throws -> Product

    func updateProductBaseInfo(productId: Int, request: ProductBaseInfoUpdateRequestDTO) async throws -> Product

    func createProductVariant(productId: Int, request: ProductVariantCreateRequestDTO) async throws -> Product

    func updateProductVariant(productId: Int, variantId: Int, request: ProductVariantCreateRequestDTO) async throws -> Product

    func deleteProductVariant(productId: Int, variantId: Int) async throws
}
