//
//  CloudflareModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import Foundation

@MainActor
final class CloudflareModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    lazy var apiService: CloudflareApiService = {
        CloudflareAPIImpl(client: apiClient)
    }()

    lazy var repository: CloudflareRepository = {
        CloudflareRepositoryImpl(api: apiService)
    }()

    lazy var getCloudflareUploadUrlUseCase: GetCloudflareUploadUrlUseCase = {
        GetCloudflareUploadUrlUseCase(repository: repository)
    }()
}
