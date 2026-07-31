//
//  MyEmployeesViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation
import Observation
import OSLog

enum EmploymentFlowError: LocalizedError {
    case employeeNotSelected
    case professionNotSelected
    case consentNotLoaded
    case requestInProgress
    
    var errorDescription: String? {
        switch self {
        case .employeeNotSelected: return "Employee not selected"
        case .professionNotSelected: return "Profession not selected"
        case .consentNotLoaded: return "Consent terms not loaded"
        case .requestInProgress: return "Request already in progress"
        }
    }
}

@Observable
@MainActor
final class MyEmployeesViewModel {
    private(set) var employeesState: FeatureState<[Employee]> = .idle
    private(set) var requestsState: FeatureState<[EmploymentRequest]> = .idle
    private(set) var searchState: FeatureState<[SearchUser]> = .idle
    private(set) var professionsState: FeatureState<[Profession]> = .idle
    private(set) var consentState: FeatureState<Consent> = .idle
    
    var searchTextEmployee: String = "" {
        didSet {
            triggerDebouncedEmployeeSearch()
        }
    }
    var selectedUserForEmployment: SearchUser? = nil
    var selectedProfessionForEmployment: Profession? = nil
    var isSaving: Bool = false
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Employees")
    
    let session: SessionManager
    private let getUserEmploymentRequestsUseCase: GetUserEmploymentRequestsUseCase
    private let getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase
    private let cancelEmploymentRequestUseCase: CancelEmploymentRequestUseCase
    private let getProfessionsByBusinessTypeUseCase: GetProfessionsByBusinessTypeUseCase
    private let getConsentByNameUseCase: GetConsentByNameUseCase
    private let createEmploymentRequestUseCase: CreateEmploymentRequestUseCase
    private let searchUsersUseCase: SearchUsersUseCase
    
    private var searchTask: Task<Void, Never>? = nil
    
    init(
        session: SessionManager,
        getUserEmploymentRequestsUseCase: GetUserEmploymentRequestsUseCase,
        getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase,
        cancelEmploymentRequestUseCase: CancelEmploymentRequestUseCase,
        searchUsersUseCase: SearchUsersUseCase,
        getProfessionsByBusinessTypeUseCase: GetProfessionsByBusinessTypeUseCase,
        getConsentByNameUseCase: GetConsentByNameUseCase,
        createEmploymentRequestUseCase: CreateEmploymentRequestUseCase
    ) {
        self.session = session
        self.getUserEmploymentRequestsUseCase = getUserEmploymentRequestsUseCase
        self.getEmployeesByOwnerUseCase = getEmployeesByOwnerUseCase
        self.cancelEmploymentRequestUseCase = cancelEmploymentRequestUseCase
        self.searchUsersUseCase = searchUsersUseCase
        self.getProfessionsByBusinessTypeUseCase = getProfessionsByBusinessTypeUseCase
        self.getConsentByNameUseCase = getConsentByNameUseCase
        self.createEmploymentRequestUseCase = createEmploymentRequestUseCase
    }
    
    func getEmployeesByOwner() async {
        guard employeesState.data == nil else { return }
        guard employeesState != .loading else { return }
        
        guard let businessOwnerId = session.userInfo?.businessOwnerId else {
            logger.error("ERROR: Business Owner ID not found in session")
            employeesState = .error("Something went wrong")
            return
        }
        
        employeesState = .loading
        
        do {
            let data = try await withLoading {
                try await getEmployeesByOwnerUseCase(businessOwnerId: businessOwnerId)
            }
            employeesState = .success(data)
        } catch {
            logger.error("ERROR: on Fetching Employees: \(error.localizedDescription)")
            employeesState = .error("Something went wrong")
        }
    }
    
    func getUserEmploymentRequests() async {
        guard requestsState.data == nil else { return }
        guard requestsState != .loading else { return }
        
        guard let userId = session.userInfo?.id else {
            logger.error("ERROR: User ID not found in session")
            requestsState = .error("Something went wrong")
            return
        }
        
        requestsState = .loading
        
        do {
            let data = try await withLoading {
                try await getUserEmploymentRequestsUseCase(userId: userId)
            }
            requestsState = .success(data)
        } catch {
            logger.error("ERROR: on Fetching Employment Requests: \(error.localizedDescription)")
            requestsState = .error("Something went wrong")
        }
    }
    
    func cancelEmploymentRequest(employmentId: Int) async {
        guard let currentRequests = requestsState.data else { return }
        guard !isSaving else { return }
        
        isSaving = true
        
        do {
            _ = try await withLoading {
                try await cancelEmploymentRequestUseCase(employmentId: employmentId)
            }
            
            var updatedRequests = currentRequests
            updatedRequests.removeAll { $0.id == employmentId }
            requestsState = .success(updatedRequests)
            
        } catch {
            logger.error("ERROR: on Cancelling Employment Request (\(employmentId)): \(error.localizedDescription)")
        }
        
        isSaving = false
    }
    
    private func triggerDebouncedEmployeeSearch() {
        searchTask?.cancel()
        
        let cleanQuery = searchTextEmployee.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanQuery.isEmpty else {
            self.searchState = .idle
            return
        }
        
        searchTask = Task {
            do {
                try await Task.sleep(for: .seconds(0.3))
                guard !Task.isCancelled else { return }
                
                self.searchState = .loading
                
                let users = try await searchUsersUseCase(query: cleanQuery, roleClient: true)
                
                guard !Task.isCancelled else { return }
                
                self.searchState = .success(users)
                
            } catch is CancellationError {
                // Nu facem nimic dacă a fost anulat controlat prin tastare rapidă
            } catch {
                guard !Task.isCancelled else { return }
                logger.error("ERROR: on Searching Users: \(error.localizedDescription)")
                self.searchState = .error("Something went wrong")
            }
        }
    }
    
    func performInstantEmployeeSearch() {
        searchTask?.cancel()
        triggerDebouncedEmployeeSearch()
    }
    
    func getProfessions() async {
        guard professionsState.data == nil else { return }
        guard professionsState != .loading else { return }
        
        guard let businessTypeId = session.userInfo?.businessTypeId else {
            logger.error("ERROR: Business Type ID not found in session")
            professionsState = .error("Something went wrong")
            return
        }
        
        professionsState = .loading
        
        do {
            let professions = try await withLoading {
                try await getProfessionsByBusinessTypeUseCase(businessTypeId: businessTypeId)
            }
            professionsState = .success(professions)
        } catch {
            logger.error("ERROR: on Fetching Professions: \(error.localizedDescription)")
            professionsState = .error("Something went wrong")
        }
    }
    
    func getConsentTerms() async {
        guard consentState.data == nil else { return }
        guard consentState != .loading else { return }
        
        consentState = .loading
        
        do {
            let consent = try await withLoading {
                try await getConsentByNameUseCase(consentName: .employmentRequestsInitiation)
            }
            consentState = .success(consent)
        } catch {
            logger.error("ERROR: on Fetching Consent Terms: \(error.localizedDescription)")
            consentState = .error("Something went wrong")
        }
    }
    
    func createEmploymentRequest() async -> Result<Void, Error> {
        guard let selectedUser = selectedUserForEmployment else {
            return .failure(EmploymentFlowError.employeeNotSelected)
        }
        
        guard let selectedProfession = selectedProfessionForEmployment else {
            return .failure(EmploymentFlowError.professionNotSelected)
        }
        
        guard let consent = consentState.data else { return .failure(EmploymentFlowError.consentNotLoaded) }
        
        guard !isSaving else { return .failure(EmploymentFlowError.requestInProgress) }
        
        isSaving = true
        
        do {
            _ = try await withLoading {
                try await createEmploymentRequestUseCase(
                    employmentId: selectedUser.id,
                    professionId: selectedProfession.id,
                    consentId: consent.id
                )
            }
            
            self.requestsState = .idle
            isSaving = false
            return .success(())
            
        } catch {
            logger.error("ERROR: on Creating Employment Request: \(error.localizedDescription)")
            isSaving = false
            return .failure(error)
        }
    }
}
