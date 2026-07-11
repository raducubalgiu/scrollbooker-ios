//
//  SearchModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

@MainActor
final class SearchModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: SearchApiService = {
        SearchAPIImpl(client: apiClient)
    }()

    private lazy var repository: SearchRepository = {
        SearchRepositoryImpl(api: apiService)
    }()

    lazy var searchUsersUseCase: SearchUsersUseCase = {
        SearchUsersUseCase(repository: repository)
    }()

    func makeFeedSearchViewModel() -> FeedSearchViewModel {
        FeedSearchViewModel(
            searchUsersUseCase: searchUsersUseCase
        )
    }
}
