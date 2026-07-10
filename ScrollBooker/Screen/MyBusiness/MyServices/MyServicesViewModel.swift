//
//  MyServicesViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class MyServicesViewModel: HasLoadingState {
    var uiState = UiState(data: [SelectedServiceDomainsWithServices]())
    
    private let session: SessionManager
    private let getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase
    private let updateBusinessServicesUseCase: UpdateBusinessServicesUseCase
    
    var defaultSelectedServiceIds: Set<Int> = []
    var selectedServiceIds: Set<Int> = []
    
    var hasChanges: Bool {
        selectedServiceIds != defaultSelectedServiceIds
    }
    
    var isLoading: Bool {
        get { uiState.isLoading }
        set { uiState.isLoading = newValue }
    }

    var errorMessage: String? {
        get { uiState.errorMessage }
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
        guard uiState.data.isEmpty else { return }
        
        uiState.errorMessage = nil
        
        guard let businessId = session.userInfo?.businessId else {
            uiState.errorMessage = "Business ID not found in session"
            return
        }
        
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
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
            
            uiState.errorMessage = message
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
        uiState.errorMessage = nil

        guard let businessId = session.userInfo?.businessId else {
            uiState.errorMessage = "Business ID not found in session"
            return
        }
        
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
        } catch {
            let message = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
            
            uiState.errorMessage = message
        }
    }
}
