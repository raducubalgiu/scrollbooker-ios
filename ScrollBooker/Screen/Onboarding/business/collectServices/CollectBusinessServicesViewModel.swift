//
//  CollectBusinessServicesViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class CollectBusinessServicesViewModel {
    private let session: SessionManager
    private let getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase
    private let collectBusinessServicesUseCase: CollectBusinessServicesUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Onboarding")

    private(set) var viewState: FeatureState<[SelectedServiceDomainsWithServices]> = .idle
    var selectedServiceIds: Set<Int> = []
    var isSaving = false
    var saveError: String?

    var isSubmitEnabled: Bool {
        !selectedServiceIds.isEmpty && !isSaving
    }

    init(
        session: SessionManager,
        getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase,
        collectBusinessServicesUseCase: CollectBusinessServicesUseCase
    ) {
        self.session = session
        self.getSelectedDomainsByBusinessUseCase = getSelectedDomainsByBusinessUseCase
        self.collectBusinessServicesUseCase = collectBusinessServicesUseCase
    }

    func loadServices() async {
        guard viewState.data == nil else { return }
        guard viewState != .loading else { return }

        viewState = .loading

        guard let businessId = session.userInfo?.businessId else {
            logger.error("ERROR: Business ID not found in session")
            viewState = .error(String(localized: "somethingWentWrong"))
            return
        }

        do {
            let data = try await withLoading {
                try await getSelectedDomainsByBusinessUseCase(businessId: businessId)
            }

            selectedServiceIds = Set(
                data.flatMap { domain in
                    domain.services.filter { $0.isSelected }.map(\.id)
                }
            )

            viewState = .success(data)
        } catch {
            viewState = .error(logger.userMessage(for: error, context: "Fetching Services"))
        }
    }

    func toggleService(serviceId: Int) {
        if selectedServiceIds.contains(serviceId) {
            selectedServiceIds.remove(serviceId)
        } else {
            selectedServiceIds.insert(serviceId)
        }
    }

    @discardableResult
    func collectBusinessServices() async -> Bool {
        guard isSubmitEnabled else { return false }

        isSaving = true
        saveError = nil

        do {
            let authState = try await withLoading {
                try await self.collectBusinessServicesUseCase(serviceIds: Array(self.selectedServiceIds))
            }
            session.updateAuthState(authState)
            isSaving = false
            return true
        } catch {
            saveError = logger.userMessage(for: error, context: "Collecting Business Services")
            isSaving = false
            return false
        }
    }
}
