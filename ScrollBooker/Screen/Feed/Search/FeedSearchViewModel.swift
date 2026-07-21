//
//  FeedSearchViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation
import Observation

enum SearchState: Equatable {
    case idle
    case loading
    case empty
    case success([SearchUser])
    case error(String)
    
    var users: [SearchUser] {
        if case .success(let users) = self { return users }
        return []
    }
}

@Observable
@MainActor
final class FeedSearchViewModel: HasLoadingState {
    private(set) var searchState: SearchState = .idle
    
    var isRefreshing: Bool = false
    private(set) var operationErrorMessage: String? = nil
    private(set) var isPerformingAction: Bool = false
    
    private var lastSearchedQuery: String = ""
    
    var searchText: String = "" {
        didSet {
            triggerDebouncedSearch()
        }
    }
    
    private let searchUsersUseCase: SearchUsersUseCase
    private var searchTask: Task<Void, Never>? = nil
    
    var isLoading: Bool {
        get {
            if case .loading = searchState { return true }
            return isPerformingAction
        }
        set { isPerformingAction = newValue }
    }

    var errorMessage: String? {
        get {
            if case .error(let msg) = searchState { return msg }
            return operationErrorMessage
        }
        set { operationErrorMessage = newValue }
    }
    
    init(searchUsersUseCase: SearchUsersUseCase) {
        self.searchUsersUseCase = searchUsersUseCase
    }
    
    private func triggerDebouncedSearch() {
        searchTask?.cancel()
        
        let cleanQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanQuery.isEmpty else {
            self.searchState = .idle
            self.lastSearchedQuery = ""
            return
        }
        
        guard cleanQuery != lastSearchedQuery else { return }
        
        searchTask = Task {
            do {
                try await Task.sleep(for: .seconds(0.3))

                guard !Task.isCancelled else { return }

                self.searchState = .loading
                self.operationErrorMessage = nil

                let users = try await withVisibleLoading {
                    try await searchUsersUseCase(query: cleanQuery, roleClient: nil)
                }
                
                guard !Task.isCancelled else { return }
                self.lastSearchedQuery = cleanQuery

                if users.isEmpty {
                    self.searchState = .empty
                } else {
                    self.searchState = .success(users)
                }
                
            } catch is CancellationError {

            } catch {
                guard !Task.isCancelled else { return }
                
                let friendlyError = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                self.searchState = .error(friendlyError)
                self.lastSearchedQuery = ""
            }
        }
    }

    func performInstantSearch() {
        searchTask?.cancel()
        
        self.lastSearchedQuery = ""
        
        triggerDebouncedSearch()
    }
    
    func clearSearchText() {
        searchTask?.cancel()
        searchTask = nil
        
        searchText = ""
        lastSearchedQuery = ""
        searchState = .idle
    }
}
