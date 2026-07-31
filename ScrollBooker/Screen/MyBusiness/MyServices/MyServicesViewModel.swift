//
//  MyServicesViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class MyServicesViewModel {
    private(set) var viewState: FeatureState<[SelectedServiceDomainsWithServices]> = .idle
    
    var isSaving: Bool = false
    var defaultSelectedServiceIds: Set<Int> = []
    var selectedServiceIds: Set<Int> = []
    
    var hasChanges: Bool {
        selectedServiceIds != defaultSelectedServiceIds
    }
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Services")
    
    private let session: SessionManager
    private let getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase
    private let updateBusinessServicesUseCase: UpdateBusinessServicesUseCase
    
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
        guard viewState.data == nil else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        
        guard let businessId = session.userInfo?.businessId else {
            logger.error("ERROR: Business ID not found in session")
            viewState = .error("Something went wrong")
            return
        }
        
        do {
            let data = try await withLoading {
                try await getSelectedDomainsByBusinessUseCase(businessId: businessId)
            }
            
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
            logger.error("ERROR: on Fetching Services: \(error.localizedDescription)")
            viewState = .error("Something went wrong")
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
        guard !isSaving else { return }
        
        isSaving = true
        let serviceIdsArray = Array(selectedServiceIds)
        
        do {
            let updatedData = try await withLoading {
                try await updateBusinessServicesUseCase(businessId: businessId, serviceIds: serviceIdsArray)
            }
            
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
        } catch {
            logger.error("ERROR: on Updating Business Services: \(error.localizedDescription)")
        }
        
        isSaving = false
    }
}

