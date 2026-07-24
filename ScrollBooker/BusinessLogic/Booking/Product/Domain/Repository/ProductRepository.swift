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
    
    func getLinkedProductsByPostId(postId: Int) async throws -> [Product]
}
