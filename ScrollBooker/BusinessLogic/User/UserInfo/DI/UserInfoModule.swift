//
//  UserInfoModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

@MainActor
final class UserInfoModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: UserInfoApiService = {
        UserInfoAPIImpl(client: apiClient)
    }()

    private lazy var repository: UserInfoRepository = {
        UserInfoRepositoryImpl(api: apiService)
    }()

    lazy var getUserInfoUseCase: GetUserInfoUseCase = {
        GetUserInfoUseCase(repository: repository)
    }()
}
