//
//  ProfessionRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

final class ProfessionRepositoryImpl: ProfessionRepository {
    private let api: ProfessionApiService
        
    init(api: ProfessionApiService) {
        self.api = api
    }
    
    func getProfessionsBybusinessType(businessTypeId: Int) async throws -> [Profession] {
        let dtoResponse = try await api.getProfessionsBybusinessType(businessTypeId: businessTypeId)
        
        return dtoResponse.map { dto in
            Profession(dto: dto)
        }
    }
}
