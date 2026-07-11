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

enum EmployeeSearchState: Equatable {
    case idle
    case loading
    case empty
    case success([SearchUser])
    case error(String)
}

enum ProfessionsState: Equatable {
    case idle
    case loading
    case empty
    case success([Profession])
    case error(String)
}


@Observable
@MainActor
final class MyEmployeesViewModel: HasLoadingState {
    private(set) var employeesState: EmployeesTabState = .idle
    private(set) var requestsState: RequestsTabState = .idle
    private(set) var searchState: EmployeeSearchState = .idle
    private(set) var professionsState: ProfessionsState = .idle
    
    var searchUserResults: [SearchUser] = []
    var searchTextEmployee: String = "" {
        didSet {
            triggerDebouncedEmployeeSearch()
        }
    }
    
    var selectedUserForEmployment: SearchUser? = nil
    var selectedProfessionForEmployment: Profession? = nil
    
    var employeesUiState = UiState(data: [Employee]())
    var employmentRequestUiState = UiState(data: [EmploymentRequest]())
    var professionsUiState = UiState(data: [Profession]())
    var isSaving: Bool = false
        
    let session: SessionManager
    private let getUserEmploymentRequestsUseCase: GetUserEmploymentRequestsUseCase
    private let getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase
    private let cancelEmploymentRequestUseCase: CancelEmploymentRequestUseCase
    private let getProfessionsByBusinessTypeUseCase: GetProfessionsByBusinessTypeUseCase
    
    private let searchUsersUseCase: SearchUsersUseCase
    private var searchTask: Task<Void, Never>? = nil
    
    var isLoading: Bool {
        get {
            employeesState == .loading ||
            requestsState == .loading ||
            searchState == .loading ||
            professionsState == .loading
        }
        set { /* Gestionat automat prin stări */ }
    }

    var errorMessage: String? {
        get {
            if case .error(let msg) = employeesState { return msg }
            if case .error(let msg) = requestsState { return msg }
            if case .error(let msg) = searchState { return msg }
            if case .error(let msg) = professionsState { return msg }
            return nil
        }
        set { /* Gestionat automat prin stări */ }
    }
 
    init(
        session: SessionManager,
        getUserEmploymentRequestsUseCase: GetUserEmploymentRequestsUseCase,
        getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase,
        cancelEmploymentRequestUseCase: CancelEmploymentRequestUseCase,
        searchUsersUseCase: SearchUsersUseCase,
        getProfessionsByBusinessTypeUseCase: GetProfessionsByBusinessTypeUseCase
    ) {
        self.session = session
        self.getUserEmploymentRequestsUseCase = getUserEmploymentRequestsUseCase
        self.getEmployeesByOwnerUseCase = getEmployeesByOwnerUseCase
        self.cancelEmploymentRequestUseCase = cancelEmploymentRequestUseCase
        self.searchUsersUseCase = searchUsersUseCase
        self.getProfessionsByBusinessTypeUseCase = getProfessionsByBusinessTypeUseCase
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
    
    private func triggerDebouncedEmployeeSearch() {
        searchTask?.cancel()
        
        let cleanQuery = searchTextEmployee.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanQuery.isEmpty else {
            self.searchState = .idle
            self.searchUserResults = []
            return
        }
        
        searchTask = Task {
            do {
                try await Task.sleep(for: .seconds(0.3))
                
                guard !Task.isCancelled else { return }
                
                if case .success = searchState, !searchUserResults.isEmpty {
                    return
                }
                
                self.searchState = .loading
                
                let users = try await searchUsersUseCase(query: cleanQuery, roleClient: true)
                
                guard !Task.isCancelled else { return }
                
                self.searchUserResults = users
                
                if users.isEmpty {
                    self.searchState = .empty
                } else {
                    self.searchState = .success(users)
                }
                
            } catch is CancellationError {

            } catch {
                guard !Task.isCancelled else { return }
                let friendlyError = error.localizedDescription
                self.searchState = .error(friendlyError)
            }
        }
    }
    
    func performInstantEmployeeSearch() {
        searchTask?.cancel()
        triggerDebouncedEmployeeSearch()
    }
    
    func getProfessions() async {
        guard professionsUiState.data.isEmpty else { return }
        guard professionsState != .loading else { return }
        
        guard let businessTypeId = session.userInfo?.businessTypeId else {
            professionsState = .error("Business Type ID not found in session")
            return
        }
        
        professionsState = .loading
        
        do {
            let professions = try await withVisibleLoading {
                try await getProfessionsByBusinessTypeUseCase(businessTypeId: businessTypeId)
            }
            
            self.professionsUiState.data = professions
            
            if professions.isEmpty {
                professionsState = .empty
            } else {
                professionsState = .success(professions)
            }
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            professionsState = .error(message)
        }
    }
}
