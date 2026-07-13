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
}
