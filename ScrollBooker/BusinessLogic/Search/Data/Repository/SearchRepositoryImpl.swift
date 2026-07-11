//
//  SearchRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

final class SearchRepositoryImpl: SearchRepository {
    private let api: SearchApiService
        
    init(api: SearchApiService) {
        self.api = api
    }
    
    func searchUsers(query: String, roleClient: Bool?) async throws -> [SearchUser] {
        let dtoResponse = try await api.searchUsers(query: query, roleClient: roleClient)
        
        return dtoResponse.map { dto in
            SearchUser(dto: dto)
        }
    }
}
