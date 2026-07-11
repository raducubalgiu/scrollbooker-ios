//
//  MyServicesViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation
import Observation

enum MyServicesState: Equatable {
    case idle
    case loading
    case success([SelectedServiceDomainsWithServices])
    case error(String)
}

@Observable
@MainActor
final class MyServicesViewModel: HasLoadingState {
    var uiState = UiState(data: [SelectedServiceDomainsWithServices]())
    
    private(set) var viewState: MyServicesState = .idle
    
    private let session: SessionManager
    private let getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase
    private let updateBusinessServicesUseCase: UpdateBusinessServicesUseCase
    
    var defaultSelectedServiceIds: Set<Int> = []
    var selectedServiceIds: Set<Int> = []
    
    var hasChanges: Bool {
        selectedServiceIds != defaultSelectedServiceIds
    }
    
    var isLoading: Bool {
        get { if case .loading = viewState { return true }; return uiState.isLoading }
        set { uiState.isLoading = newValue }
    }

    var errorMessage: String? {
        get { if case .error(let msg) = viewState { return msg }; return uiState.errorMessage }
        set { uiState.errorMessage = newValue }
    }
    
    init(
        session: SessionManager,
        getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase,
        updateBusinessServicesUseCase: UpdateBusinessServicesUseCase
    ) {
        self.session = session
        self.getSelectedDomainsByBusinessUseCase = getSelectedDomainsByBusinessUseCase
        self.updateBusinessServicesUseCase = updateBusinessServicesUseCase
    }
    
    func loadServices() async {
        guard viewState != .loading else { return }
        
        guard let businessId = session.userInfo?.businessId else {
            viewState = .error("Business ID not found in session")
            return
        }
        
        viewState = .loading
        uiState.errorMessage = nil
        
        do {
            let data = try await withVisibleLoading {
                try await getSelectedDomainsByBusinessUseCase(businessId: businessId)
            }
            uiState.data = data
            
            let initialSelectedIds = Set(
                data.flatMap { domain in
                    domain.services
                        .filter { $0.isSelected }
                        .map { $0.id }
                }
            )
            
            self.defaultSelectedServiceIds = initialSelectedIds
            self.selectedServiceIds = initialSelectedIds
            
            viewState = .success(data)
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            viewState = .error(message)
        }
    }
    
    func toggleService(serviceId: Int) {
        if selectedServiceIds.contains(serviceId) {
            selectedServiceIds.remove(serviceId)
        } else {
            selectedServiceIds.insert(serviceId)
        }
    }
    
    func updateBusinessServices() async {
        guard let businessId = session.userInfo?.businessId else { return }

        uiState.isLoading = true
        uiState.errorMessage = nil
        
        let serviceIdsArray = Array(selectedServiceIds)
        
        do {
            let updatedData = try await withVisibleLoading {
                try await updateBusinessServicesUseCase(businessId: businessId, serviceIds: serviceIdsArray)
            }
            
            uiState.data = updatedData

            let freshSelectedIds = Set(
                updatedData.flatMap { domain in
                    domain.services
                        .filter { $0.isSelected }
                        .map { $0.id }
                }
            )
            
            self.defaultSelectedServiceIds = freshSelectedIds
            self.selectedServiceIds = freshSelectedIds
            
            viewState = .success(updatedData)
            uiState.isLoading = false
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            uiState.errorMessage = message
            uiState.isLoading = false
        }
    }
}
