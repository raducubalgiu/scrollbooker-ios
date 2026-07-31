//
//  AddProductsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.07.2026.
//

import Observation
import Foundation

@Observable
final class AddProductViewModel {
    var name: String = ""
    var description: String = ""
    
    var selectedCategoryId: String = "" {
        didSet {
            selectedServiceId = ""
        }
    }
    var selectedServiceId: String = ""
        
    private(set) var domainsViewState: FeatureState<[SelectedServiceDomainsWithServices]> = .idle
    private(set) var employeesViewState: FeatureState<[Employee]> = .idle
    
    private let session: SessionManager
    private let getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase
    private let getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase
    
    init(
        session: SessionManager,
        getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase,
        getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase
    ) {
        self.session = session
        self.getSelectedDomainsByBusinessUseCase = getSelectedDomainsByBusinessUseCase
        self.getEmployeesByOwnerUseCase = getEmployeesByOwnerUseCase
        
        fetchDomains(businessId: 7)
        fetchEmployees(businessOwnerId: 12)
    }
    
    func fetchDomains(businessId: Int) {
        domainsViewState = .loading
        
        Task { @MainActor in
            do {
                let domains = try await withLoading {
                    try await getSelectedDomainsByBusinessUseCase(businessId: businessId)
                }
                self.domainsViewState = .success(domains)
            } catch {
                self.domainsViewState = .error(error.localizedDescription)
            }
        }
    }
    
    func fetchEmployees(businessOwnerId: Int) {
        employeesViewState = .loading
        
        Task { @MainActor in
            do {
                let employees = try await getEmployeesByOwnerUseCase(businessOwnerId: businessOwnerId)
                self.employeesViewState = .success(employees)
            } catch {
                self.employeesViewState = .error(error.localizedDescription)
            }
        }
    }
    
    var categories: [SelectOption] {
        guard let domains = domainsViewState.data else { return [] }
        return domains.map { domain in
            SelectOption(value: String(domain.id), name: domain.name)
        }
    }
    
    var filteredServices: [SelectOption] {
        guard let categoryIdInt = Int(selectedCategoryId),
              let domains = domainsViewState.data else { return [] }
        
        let selectedDomain = domains.first { $0.id == categoryIdInt }
        return selectedDomain?.services.map { service in
            SelectOption(value: String(service.id), name: service.name)
        } ?? []
    }
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !selectedCategoryId.isEmpty &&
        !selectedServiceId.isEmpty
    }
    
    func saveProduct() {
        guard isFormValid else { return }
        print("Salvare produs: \(name), Categorie: \(selectedCategoryId), Serviciu: \(selectedServiceId)")
    }
}

