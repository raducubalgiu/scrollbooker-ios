//
//  EmploymentRequestsModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation

@MainActor
final class EmploymentRequestModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: EmploymentRequestApiService = {
        EmploymentRequestAPIImpl(client: apiClient)
    }()

    private lazy var repository: EmploymentRequestRepository = {
        EmploymentRequestRepositoryImpl(api: apiService)
    }()
    
    private lazy var getUserEmploymentRequestsUseCase: GetUserEmploymentRequestsUseCase = {
        GetUserEmploymentRequestsUseCase(repository: repository)
    }()
    
    private lazy var cancelEmploymentRequestUseCase: CancelEmploymentRequestUseCase = {
        CancelEmploymentRequestUseCase(repository: repository)
    }()
    
    func makeMyEmployeesViewModel(
        session: SessionManager,
        getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase,
        searchUsersUseCase: SearchUsersUseCase,
        getProfessionsByBusinessTypeUseCase: GetProfessionsByBusinessTypeUseCase,
        getConsentByNameUseCase: GetConsentByNameUseCase
    ) -> MyEmployeesViewModel {
        MyEmployeesViewModel(
            session: session,
            getUserEmploymentRequestsUseCase: getUserEmploymentRequestsUseCase,
            getEmployeesByOwnerUseCase: getEmployeesByOwnerUseCase,
            cancelEmploymentRequestUseCase: cancelEmploymentRequestUseCase,
            searchUsersUseCase: searchUsersUseCase,
            getProfessionsByBusinessTypeUseCase: getProfessionsByBusinessTypeUseCase,
            getConsentByNameUseCase: getConsentByNameUseCase
        )
    }
}
