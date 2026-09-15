//
//  CollectBusinessViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class CollectBusinessViewModel {
    private let session: SessionManager
    private let collectBusinessUseCase: CollectBusinessUseCase
    private let getUserInfoUseCase: GetUserInfoUseCase
    private let searchBusinessAddressUseCase: SearchBusinessAddressUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Onboarding")

    private let nameMinLength = 3
    private let nameMaxLength = 35
    private let descriptionMaxLength = 255
    private let addressQueryMinLength = 2

    var businessName: String = ""
    var businessDescription: String = ""

    let businessTypesPaginator: Paginator<BusinessType>
    var selectedBusinessType: BusinessType?

    var selectedAddress: BusinessAddress?
    private(set) var addressSearchState: FeatureState<[BusinessAddress]> = .idle

    var addressQuery: String = "" {
        didSet { triggerAddressSearch() }
    }
    private var lastSearchedAddressQuery: String = ""
    private var addressSearchTask: Task<Void, Never>?

    var isSaving = false
    var saveError: String?

    var nameErrorMessage: String? {
        guard !businessName.isEmpty else { return nil }
        if businessName.count < nameMinLength {
            return String(format: String(localized: "minLengthValidationMessage"), nameMinLength)
        }
        if businessName.count > nameMaxLength {
            return String(format: String(localized: "maxLengthValidationMessage"), nameMaxLength)
        }
        return nil
    }

    var descriptionErrorMessage: String? {
        guard businessDescription.count > descriptionMaxLength else { return nil }
        return String(format: String(localized: "maxLengthValidationMessage"), descriptionMaxLength)
    }

    var isDetailsStepValid: Bool {
        !businessName.isEmpty && nameErrorMessage == nil && descriptionErrorMessage == nil
    }

    var isLocationStepValid: Bool {
        selectedAddress != nil && !isSaving
    }

    init(
        session: SessionManager,
        collectBusinessUseCase: CollectBusinessUseCase,
        getUserInfoUseCase: GetUserInfoUseCase,
        getAllPaginatedBusinessTypesUseCase: GetAllPaginatedBusinessTypesUseCase,
        searchBusinessAddressUseCase: SearchBusinessAddressUseCase
    ) {
        self.session = session
        self.collectBusinessUseCase = collectBusinessUseCase
        self.getUserInfoUseCase = getUserInfoUseCase
        self.searchBusinessAddressUseCase = searchBusinessAddressUseCase
        self.businessTypesPaginator = Paginator { page, limit in
            try await getAllPaginatedBusinessTypesUseCase(page: page, limit: limit)
        }
    }

    func retryAddressSearch() {
        triggerAddressSearch()
    }

    private func triggerAddressSearch() {
        addressSearchTask?.cancel()

        let cleanQuery = addressQuery.trimmingCharacters(in: .whitespacesAndNewlines)

        guard cleanQuery.count >= addressQueryMinLength else {
            addressSearchState = .idle
            lastSearchedAddressQuery = ""
            return
        }

        guard cleanQuery != lastSearchedAddressQuery else { return }

        addressSearchTask = Task {
            do {
                try await Task.sleep(for: .seconds(0.3))

                guard !Task.isCancelled else { return }
                addressSearchState = .loading

                let results = try await withLoading {
                    try await self.searchBusinessAddressUseCase(query: cleanQuery)
                }

                guard !Task.isCancelled else { return }
                lastSearchedAddressQuery = cleanQuery

                addressSearchState = .success(results)
            } catch is CancellationError {

            } catch {
                guard !Task.isCancelled else { return }

                addressSearchState = .error(
                    logger.userMessage(for: error, context: "Searching Business Address (\(cleanQuery))")
                )
                lastSearchedAddressQuery = ""
            }
        }
    }

    @discardableResult
    func createBusiness() async -> Bool {
        guard let placeId = selectedAddress?.placeId, let businessTypeId = selectedBusinessType?.id else {
            logger.error("ERROR: on Creating Business: place id or business type id is missing")
            saveError = String(localized: "somethingWentWrong")
            return false
        }

        isSaving = true
        saveError = nil

        do {
            let freshUserInfo = try await withLoading {
                _ = try await self.collectBusinessUseCase(
                    description: self.businessDescription.isEmpty ? nil : self.businessDescription,
                    placeId: placeId,
                    businessTypeId: businessTypeId,
                    ownerFullName: self.businessName
                )
                // La fel ca la collectUsername: refacem fetch complet de UserInfo (are deja
                // businessId/businessTypeId/registrationStep) în loc să persistăm manual
                // valorile în AuthStore — setBusinessId/setBusinessTypeId au fost eliminate
                // din AuthStore fiindcă nu mai aveau niciun apelant.
                return try await self.getUserInfoUseCase()
            }
            session.setAuthenticated(freshUserInfo)
            isSaving = false
            return true
        } catch {
            saveError = logger.userMessage(for: error, context: "Creating Business")
            isSaving = false
            return false
        }
    }
}
