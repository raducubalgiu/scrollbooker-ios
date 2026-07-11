//
//  EmployeesRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

final class EmployeesRepositoryImpl: EmployeesRepository {    
    private let api: EmployeeApiService
        
    init(api: EmployeeApiService) {
        self.api = api
    }
    
    func getEmployeesByOwner(businessOwnerId: Int) async throws -> [Employee] {
        let dtoResponse = try await api.getEmployeesByOwner(businessOwnerId: businessOwnerId)
        
        return try dtoResponse.map { dto in
            try Employee(dto: dto)
        }
    }
}
