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
    private let getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase
    private let getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase

    init(
        apiClient: APIClient,
        getUserInfoUseCase: GetUserInfoUseCase,
        searchUsernameUseCase: SearchUsernameUseCase,
        getAllPaginatedBusinessTypesUseCase: GetAllPaginatedBusinessTypesUseCase,
        searchBusinessAddressUseCase: SearchBusinessAddressUseCase,
        getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase,
        getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase
    ) {
        self.apiClient = apiClient
        self.getUserInfoUseCase = getUserInfoUseCase
        self.searchUsernameUseCase = searchUsernameUseCase
        self.getAllPaginatedBusinessTypesUseCase = getAllPaginatedBusinessTypesUseCase
        self.searchBusinessAddressUseCase = searchBusinessAddressUseCase
        self.getSelectedDomainsByBusinessUseCase = getSelectedDomainsByBusinessUseCase
        self.getSchedulesByUserIdUseCase = getSchedulesByUserIdUseCase
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

    lazy var collectClientBirthdateUseCase: CollectClientBirthdateUseCase = {
        CollectClientBirthdateUseCase(repository: repository)
    }()

    lazy var collectClientGenderUseCase: CollectClientGenderUseCase = {
        CollectClientGenderUseCase(repository: repository)
    }()

    lazy var collectClientLocationPermissionUseCase: CollectClientLocationPermissionUseCase = {
        CollectClientLocationPermissionUseCase(repository: repository)
    }()

    lazy var collectBusinessUseCase: CollectBusinessUseCase = {
        CollectBusinessUseCase(repository: repository)
    }()

    lazy var collectBusinessGalleryUseCase: CollectBusinessGalleryUseCase = {
        CollectBusinessGalleryUseCase(repository: repository)
    }()

    lazy var collectBusinessServicesUseCase: CollectBusinessServicesUseCase = {
        CollectBusinessServicesUseCase(repository: repository)
    }()

    lazy var collectBusinessSchedulesUseCase: CollectBusinessSchedulesUseCase = {
        CollectBusinessSchedulesUseCase(repository: repository)
    }()

    lazy var collectBusinessHasEmployeesUseCase: CollectBusinessHasEmployeesUseCase = {
        CollectBusinessHasEmployeesUseCase(repository: repository)
    }()

    func makeCollectUsernameViewModel(session: SessionManager) -> CollectUsernameViewModel {
        CollectUsernameViewModel(
            session: session,
            collectUserUsernameUseCase: collectUserUsernameUseCase,
            searchUsernameUseCase: searchUsernameUseCase,
            getUserInfoUseCase: getUserInfoUseCase
        )
    }

    func makeCollectBirthdateViewModel(session: SessionManager) -> CollectBirthdateViewModel {
        CollectBirthdateViewModel(
            session: session,
            collectClientBirthdateUseCase: collectClientBirthdateUseCase
        )
    }

    func makeCollectGenderViewModel(session: SessionManager) -> CollectGenderViewModel {
        CollectGenderViewModel(
            session: session,
            collectClientGenderUseCase: collectClientGenderUseCase
        )
    }

    func makeCollectLocationPermissionViewModel(session: SessionManager) -> CollectLocationPermissionViewModel {
        CollectLocationPermissionViewModel(
            session: session,
            collectClientLocationPermissionUseCase: collectClientLocationPermissionUseCase
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

    func makeCollectBusinessServicesViewModel(session: SessionManager) -> CollectBusinessServicesViewModel {
        CollectBusinessServicesViewModel(
            session: session,
            getSelectedDomainsByBusinessUseCase: getSelectedDomainsByBusinessUseCase,
            collectBusinessServicesUseCase: collectBusinessServicesUseCase
        )
    }

    func makeCollectBusinessSchedulesViewModel(session: SessionManager) -> CollectBusinessSchedulesViewModel {
        CollectBusinessSchedulesViewModel(
            session: session,
            getSchedulesByUserIdUseCase: getSchedulesByUserIdUseCase,
            collectBusinessSchedulesUseCase: collectBusinessSchedulesUseCase
        )
    }

    func makeCollectBusinessHasEmployeesViewModel(session: SessionManager) -> CollectBusinessHasEmployeesViewModel {
        CollectBusinessHasEmployeesViewModel(
            session: session,
            collectBusinessHasEmployeesUseCase: collectBusinessHasEmployeesUseCase
        )
    }
}
