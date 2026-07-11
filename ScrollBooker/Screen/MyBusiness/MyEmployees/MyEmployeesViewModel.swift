//
//  MyEmployeesViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation
import Observation

enum EmployeesTabState: Equatable {
    case idle
    case loading
    case success([Employee])
    case empty
    case error(String)
}

enum RequestsTabState: Equatable {
    case idle
    case loading
    case success([EmploymentRequest])
    case empty
    case error(String)
}


@Observable
@MainActor
final class MyEmployeesViewModel: HasLoadingState {
    private(set) var employeesState: EmployeesTabState = .idle
    private(set) var requestsState: RequestsTabState = .idle
    
    var employeesUiState = UiState(data: [Employee]())
    var employmentRequestUiState = UiState(data: [EmploymentRequest]())
    var isSaving: Bool = false
    
    let session: SessionManager
    private let getUserEmploymentRequestsUseCase: GetUserEmploymentRequestsUseCase
    private let getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase
    private let cancelEmploymentRequestUseCase: CancelEmploymentRequestUseCase
    
    // MARK: - HasLoadingState (Sincronizat corect)
    var isLoading: Bool {
        get { employeesState == .loading || requestsState == .loading }
        set { /* Not needed anymore, handled by state */ }
    }

    var errorMessage: String? {
        get {
            if case .error(let msg) = employeesState { return msg }
            if case .error(let msg) = requestsState { return msg }
            return nil
        }
        set { /* Handled by state */ }
    }
 
    init(
        session: SessionManager,
        getUserEmploymentRequestsUseCase: GetUserEmploymentRequestsUseCase,
        getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase,
        cancelEmploymentRequestUseCase: CancelEmploymentRequestUseCase
    ) {
        self.session = session
        self.getUserEmploymentRequestsUseCase = getUserEmploymentRequestsUseCase
        self.getEmployeesByOwnerUseCase = getEmployeesByOwnerUseCase
        self.cancelEmploymentRequestUseCase = cancelEmploymentRequestUseCase
    }
    
    func getEmployeesByOwner() async {
        guard employeesUiState.data.isEmpty else { return }
        guard employeesState != .loading else { return }
        
        guard let businessOwnerId = session.userInfo?.businessOwnerId else {
            employeesState = .error("User ID not found in session")
            return
        }
        
        employeesState = .loading
        
        do {
            let data = try await withVisibleLoading {
                try await getEmployeesByOwnerUseCase(businessOwnerId: businessOwnerId)
            }
            
            self.employeesUiState.data = data
            
            if data.isEmpty {
                employeesState = .empty
            } else {
                employeesState = .success(data)
            }
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            employeesState = .error(message)
        }
    }
    
    func getUserEmploymentRequests() async {
        guard employmentRequestUiState.data.isEmpty else { return }
        guard requestsState != .loading else { return }
        
        guard let userId = session.userInfo?.id else {
            requestsState = .error("User ID not found in session")
            return
        }
        
        requestsState = .loading
        
        do {
            let data = try await withVisibleLoading {
                try await getUserEmploymentRequestsUseCase(userId: userId)
            }
            
            self.employmentRequestUiState.data = data
            
            if data.isEmpty {
                requestsState = .empty
            } else {
                requestsState = .success(data)
            }
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            requestsState = .error(message)
        }
    }
    
    func cancelEmploymentRequest(employmentId: Int) async {
            guard !isSaving else { return }
            
            isSaving = true
            
            if case .error = requestsState {
                // Dacă ecranul era blocat pe eroare (teoretic nu e cazul la ștergere), îl resetăm
            }
            
            do {
                _ = try await withVisibleLoading {
                    try await cancelEmploymentRequestUseCase(employmentId: employmentId)
                }
                
                self.employmentRequestUiState.data.removeAll { $0.id == employmentId }
                if employmentRequestUiState.data.isEmpty {
                    self.requestsState = .empty
                } else {
                    self.requestsState = .success(employmentRequestUiState.data)
                }
                
                isSaving = false
                
            } catch {
                let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                
                print("Eroare la anularea cererii de angajare: \(message)")
                isSaving = false
            }
        }
}
