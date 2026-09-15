//
//  OnboardingModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

@MainActor
final class OnboardingModule {
    private let apiClient: APIClient
    private let getUserInfoUseCase: GetUserInfoUseCase
    private let searchUsernameUseCase: SearchUsernameUseCase
    private let getAllPaginatedBusinessTypesUseCase: GetAllPaginatedBusinessTypesUseCase
    private let searchBusinessAddressUseCase: SearchBusinessAddressUseCase

    init(
        apiClient: APIClient,
        getUserInfoUseCase: GetUserInfoUseCase,
        searchUsernameUseCase: SearchUsernameUseCase,
        getAllPaginatedBusinessTypesUseCase: GetAllPaginatedBusinessTypesUseCase,
        searchBusinessAddressUseCase: SearchBusinessAddressUseCase
    ) {
        self.apiClient = apiClient
        self.getUserInfoUseCase = getUserInfoUseCase
        self.searchUsernameUseCase = searchUsernameUseCase
        self.getAllPaginatedBusinessTypesUseCase = getAllPaginatedBusinessTypesUseCase
        self.searchBusinessAddressUseCase = searchBusinessAddressUseCase
    }

    private lazy var apiService: OnboardingApiService = {
        OnboardingAPIImpl(client: apiClient)
    }()

    private lazy var repository: OnboardingRepository = {
        OnboardingRepositoryImpl(api: apiService)
    }()

    lazy var collectUserUsernameUseCase: CollectUserUsernameUseCase = {
        CollectUserUsernameUseCase(repository: repository)
    }()

    lazy var collectBusinessUseCase: CollectBusinessUseCase = {
        CollectBusinessUseCase(repository: repository)
    }()

    lazy var collectBusinessGalleryUseCase: CollectBusinessGalleryUseCase = {
        CollectBusinessGalleryUseCase(repository: repository)
    }()

    func makeCollectUsernameViewModel(session: SessionManager) -> CollectUsernameViewModel {
        CollectUsernameViewModel(
            session: session,
            collectUserUsernameUseCase: collectUserUsernameUseCase,
            searchUsernameUseCase: searchUsernameUseCase,
            getUserInfoUseCase: getUserInfoUseCase
        )
    }

    func makeCollectBusinessViewModel(session: SessionManager) -> CollectBusinessViewModel {
        CollectBusinessViewModel(
            session: session,
            collectBusinessUseCase: collectBusinessUseCase,
            getUserInfoUseCase: getUserInfoUseCase,
            getAllPaginatedBusinessTypesUseCase: getAllPaginatedBusinessTypesUseCase,
            searchBusinessAddressUseCase: searchBusinessAddressUseCase
        )
    }

    func makeCollectBusinessGalleryViewModel(session: SessionManager) -> CollectBusinessGalleryViewModel {
        CollectBusinessGalleryViewModel(
            session: session,
            collectBusinessGalleryUseCase: collectBusinessGalleryUseCase
        )
    }
}
