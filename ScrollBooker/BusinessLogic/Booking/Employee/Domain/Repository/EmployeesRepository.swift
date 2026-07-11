//
//  EmployeesRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

protocol EmployeesRepository: Sendable {
    func getEmployeesByOwner(businessOwnerId: Int) async throws -> [Employee]
}
