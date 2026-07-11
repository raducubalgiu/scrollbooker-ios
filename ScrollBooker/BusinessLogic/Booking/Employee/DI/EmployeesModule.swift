//
//  EmployeesModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

@MainActor
final class EmployeesModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: EmployeeApiService = {
        EmployeeAPIImpl(client: apiClient)
    }()

    private lazy var repository: EmployeesRepository = {
        EmployeesRepositoryImpl(api: apiService)
    }()
    
    lazy var getEmployeesByOwner: GetEmployeesByOwnerUseCase = {
        GetEmployeesByOwnerUseCase(repository: repository)
    }()
}
