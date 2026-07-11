//
//  GetEmployeesbyOwnerUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

final class GetEmployeesByOwnerUseCase {
    private let repository: EmployeesRepository

    init(repository: EmployeesRepository) {
        self.repository = repository
    }

    func callAsFunction(businessOwnerId: Int) async throws -> [Employee] {
        try await repository.getEmployeesByOwner(businessOwnerId: businessOwnerId)
    }
}
