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
    var employeesUiState = UiState(data: [Employee]())
    var employmentRequestUiState = UiState(data: [EmploymentRequest]())
    var isSaving: Bool = false
    
    let session: SessionManager
    private let getUserEmploymentRequestsUseCase: GetUserEmploymentRequestsUseCase
    private let getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase
    
    var isLoading: Bool {
        get { employeesUiState.isLoading }
        set { employeesUiState.isLoading = newValue }
    }

    var errorMessage: String? {
        get { employeesUiState.errorMessage }
        set { employeesUiState.errorMessage = newValue }
    }
 
    init(
        session: SessionManager,
        getUserEmploymentRequestsUseCase: GetUserEmploymentRequestsUseCase,
        getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase
    ) {
        self.session = session
        self.getUserEmploymentRequestsUseCase = getUserEmploymentRequestsUseCase
        self.getEmployeesByOwnerUseCase = getEmployeesByOwnerUseCase
    }
    
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
    
    func cancelEmploymentRequest(id: Int) {
        Task {
            isSaving = true
            // try? await cancelUseCase.execute(id: id)
            isSaving = false
        }
    }
}
