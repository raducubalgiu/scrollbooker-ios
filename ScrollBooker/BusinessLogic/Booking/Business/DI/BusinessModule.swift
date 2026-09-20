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
    private let updateSchedulesUseCase: UpdateSchedulesUseCase

    init(apiClient: APIClient, updateSchedulesUseCase: UpdateSchedulesUseCase) {
        self.apiClient = apiClient
        self.updateSchedulesUseCase = updateSchedulesUseCase
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

    lazy var getMyBusinessDetailsUseCase: GetMyBusinessDetailsUseCase = {
        GetMyBusinessDetailsUseCase(repository: repository)
    }()

    private lazy var getUnapprovedBusinessesUseCase: GetUnapprovedBusinessesUseCase = {
        GetUnapprovedBusinessesUseCase(repository: repository)
    }()

    private lazy var approveBusinessUseCase: ApproveBusinessUseCase = {
        ApproveBusinessUseCase(repository: repository)
    }()

    lazy var searchBusinessAddressUseCase: SearchBusinessAddressUseCase = {
        SearchBusinessAddressUseCase(repository: repository)
    }()

    lazy var updateBusinessGalleryUseCase: UpdateBusinessGalleryUseCase = {
        UpdateBusinessGalleryUseCase(repository: repository)
    }()

    func makeSearchViewModel(
        getAllBusinessDomainsUseCase: GetAllBusinessDomainsUseCase
    ) -> SearchViewModel {
        SearchViewModel(
            getBusinessesSheetUseCase: getBusinessesSheetUseCase,
            getBusinessesMarkersUseCase: getBusinessesMarkersUseCase,
            getAllBusinessDomainsUseCase: getAllBusinessDomainsUseCase
        )
    }
    
    func makeBusinessProfileViewModel(username: String) -> BusinessProfileViewModel {
        BusinessProfileViewModel(
            username: username,
            getBusinessProfileUseCase: getBusinessProfileUseCase
        )
    }

    func makeUnapprovedBusinessesViewModel() -> UnapprovedBusinessesViewModel {
        UnapprovedBusinessesViewModel(
            getUnapprovedBusinessesUseCase: getUnapprovedBusinessesUseCase,
            approveBusinessUseCase: approveBusinessUseCase
        )
    }

    func makeMyBusinessDetailsViewModel(session: SessionManager, toastCenter: ToastCenter) -> MyBusinessDetailsViewModel {
        MyBusinessDetailsViewModel(
            session: session,
            toastCenter: toastCenter,
            getMyBusinessDetailsUseCase: getMyBusinessDetailsUseCase,
            updateBusinessGalleryUseCase: updateBusinessGalleryUseCase,
            updateSchedulesUseCase: updateSchedulesUseCase
        )
    }
}
