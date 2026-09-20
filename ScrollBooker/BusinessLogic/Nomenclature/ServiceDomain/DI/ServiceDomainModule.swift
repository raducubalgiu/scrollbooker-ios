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

    lazy var getAllServiceDomainsUseCase: GetAllServiceDomainsUseCase = {
        GetAllServiceDomainsUseCase(repository: repository)
    }()

    lazy var getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase = {
        GetSelectedDomainsByBusinesssUseCase(repository: repository)
    }()
    
    private lazy var updateBusinessServicesUseCase: UpdateBusinessServicesUseCase = {
        UpdateBusinessServicesUseCase(repository: repository)
    }()

    func makeMyServicesViewModel(session: SessionManager, toastCenter: ToastCenter) -> MyServicesViewModel {
        MyServicesViewModel(
            session: session,
            toastCenter: toastCenter,
            getSelectedDomainsByBusinessUseCase: getSelectedDomainsByBusinessUseCase,
            updateBusinessServicesUseCase: updateBusinessServicesUseCase
        )
    }
}
