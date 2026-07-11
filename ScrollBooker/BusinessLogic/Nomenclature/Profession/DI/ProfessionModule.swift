//
//  ProfessionModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

@MainActor
final class ProfessionModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: ProfessionApiService = {
        ProfessionAPIImpl(client: apiClient)
    }()

    private lazy var repository: ProfessionRepository = {
        ProfessionRepositoryImpl(api: apiService)
    }()
    
    lazy var getProfessionsByBusinessTypeUseCase: GetProfessionsByBusinessTypeUseCase = {
        GetProfessionsByBusinessTypeUseCase(repository: repository)
    }()
}
