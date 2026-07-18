//
//  BusinessModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation

@MainActor
final class BusinessModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: BusinessApiService = {
        BusinessAPIImpl(client: apiClient)
    }()

    private lazy var repository: BusinessRepository = {
        BusinessRepositoryImpl(api: apiService)
    }()

    private lazy var getBusinessesSheetUseCase: GetBusinessesSheetUseCase = {
        GetBusinessesSheetUseCase(repository: repository)
    }()
    
    private lazy var getBusinessesMarkersUseCase: GetBusinessesMarkersUseCase = {
        GetBusinessesMarkersUseCase(repository: repository)
    }()
    
    private lazy var getBusinessProfileUseCase: GetBusinessProfileUseCase = {
        GetBusinessProfileUseCase(repository: repository)
    }()

    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(
            getBusinessesSheetUseCase: getBusinessesSheetUseCase,
            getBusinessesMarkersUseCase: getBusinessesMarkersUseCase
        )
    }
    
    func makeBusinessProfileViewModel(username: String) -> BusinessProfileViewModel {
        BusinessProfileViewModel(
            username: username,
            getBusinessProfileUseCase: getBusinessProfileUseCase
        )
    }
}
