//
//  ConsentModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

@MainActor
final class ConsentModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: ConsentApiService = {
        ConsentAPIImpl(client: apiClient)
    }()

    private lazy var repository: ConsentRepository = {
        ConsentRepositoryImpl(api: apiService)
    }()
    
    lazy var getConsentByNameUseCase: GetConsentByNameUseCase = {
        GetConsentByNameUseCase(repository: repository)
    }()
}
