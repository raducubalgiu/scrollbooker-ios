//
//  MyEmployeesViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class MyEmployeesViewModel: HasLoadingState {
    // Cele două stări de UI independente pentru fiecare tab în parte
    var employeesUiState = UiState(data: [Employee]())
    var employmentRequestUiState = UiState(data: [EmploymentRequest]())
    var isSaving: Bool = false
    
    let session: SessionManager
    private let getUserEmploymentRequestsUseCase: GetUserEmploymentRequestsUseCase
    private let getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase
    
    // MARK: - HasLoadingState Conformance (Unificată Enterprise)
    
    /// Devine true dacă oricare dintre cele două tab-uri încarcă date activ pe rețea
    var isLoading: Bool {
        get { employeesUiState.isLoading || employmentRequestUiState.isLoading }
        set {
            // Când utilitarul withVisibleLoading modifică flag-ul, îl propagăm în ambele stări
            employeesUiState.isLoading = newValue
            employmentRequestUiState.isLoading = newValue
        }
    }

    /// Prinde și expune în UI eroarea sosită de pe oricare dintre tab-uri
    var errorMessage: String? {
        get { employeesUiState.errorMessage ?? employmentRequestUiState.errorMessage }
        set {
            // Sincronizăm curățarea sau setarea erorilor pe ambele containere
            employeesUiState.errorMessage = newValue
            employmentRequestUiState.errorMessage = newValue
        }
    }
 
    // MARK: - Init
    init(
        session: SessionManager,
        getUserEmploymentRequestsUseCase: GetUserEmploymentRequestsUseCase,
        getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase
    ) {
        self.session = session
        self.getUserEmploymentRequestsUseCase = getUserEmploymentRequestsUseCase
        self.getEmployeesByOwnerUseCase = getEmployeesByOwnerUseCase
    }
    
    // MARK: - Public Actions
    
    /// Încarcă lista de angajați pentru primul tab
    func getEmployeesByOwner() async {
        guard employeesUiState.data.isEmpty else { return }
        
        employeesUiState.errorMessage = nil
        
        guard let businessOwnerId = session.userInfo?.businessOwnerId else {
            employeesUiState.errorMessage = "User ID not found in session"
            return
        }
        
        do {
            let data = try await withVisibleLoading {
                try await getEmployeesByOwnerUseCase(businessOwnerId: businessOwnerId)
            }
            
            self.employeesUiState.data = data
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
            
            employeesUiState.errorMessage = message
        }
    }
    
    /// Încarcă cererile de angajare pentru al doilea tab
    func getUserEmploymentRequests() async {
        guard employmentRequestUiState.data.isEmpty else { return }
        
        employmentRequestUiState.errorMessage = nil
        
        guard let userId = session.userInfo?.id else {
            employmentRequestUiState.errorMessage = "User ID not found in session"
            return
        }
        
        do {
            let data = try await withVisibleLoading {
                try await getUserEmploymentRequestsUseCase(userId: userId)
            }
            
            self.employmentRequestUiState.data = data
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
            
            employmentRequestUiState.errorMessage = message
        }
    }
}
