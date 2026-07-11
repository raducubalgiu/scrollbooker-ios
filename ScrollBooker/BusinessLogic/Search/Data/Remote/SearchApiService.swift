//
//  SearchApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

protocol SearchApiService: Sendable {
    func searchUsers(query: String, roleClient: Bool?) async throws -> [SearchUserDto]
}

final class SearchAPIImpl: SearchApiService, @unchecked Sendable {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func searchUsers(query: String, roleClient: Bool?) async throws -> [SearchUserDto] {
        var queryParameters: [String: String] = [
            "query": query
        ]
        
        if let roleClient = roleClient {
            queryParameters["role_client"] = String(roleClient)
        }
        
        return try await client.request(
            "search/users",
            method: .get,
            query: queryParameters
        )
    }
}
