//
//  ServiceDomainModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation

@MainActor
final class ServiceDomainModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: ServiceDomainApiService = {
        ServiceDomainAPIImpl(client: apiClient)
    }()

    private lazy var repository: ServiceDomainRepository = {
        ServiceDomainRepositoryImpl(api: apiService)
    }()

    private lazy var getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase = {
        GetSelectedDomainsByBusinesssUseCase(repository: repository)
    }()
    
    private lazy var updateBusinessServicesUseCase: UpdateBusinessServicesUseCase = {
        UpdateBusinessServicesUseCase(repository: repository)
    }()

    func makeMyServicesViewModel(session: SessionManager) -> MyServicesViewModel {
        MyServicesViewModel(
            session: session,
            getSelectedDomainsByBusinessUseCase: getSelectedDomainsByBusinessUseCase,
            updateBusinessServicesUseCase: updateBusinessServicesUseCase
        )
    }
}
