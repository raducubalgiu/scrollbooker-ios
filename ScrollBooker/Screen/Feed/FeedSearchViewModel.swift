//
//  FeedSearchViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation
import Observation

enum SearchState {
    case idle
    case loading
    case empty
    case success([SearchUser])
    case error(String)
}

@Observable
@MainActor
final class FeedSearchViewModel: HasLoadingState {
    var uiState = UiState(data: [SearchUser]())
    
    private(set) var searchState: SearchState = .idle
    var searchText: String = "" {
        didSet {
            triggerDebouncedSearch()
        }
    }
    
    private let searchUsersUseCase: SearchUsersUseCase
    private var searchTask: Task<Void, Never>? = nil

    var isLoading: Bool {
        get { uiState.isLoading }
        set { uiState.isLoading = newValue }
    }

    var errorMessage: String? {
        get { uiState.errorMessage }
        set { uiState.errorMessage = newValue }
    }

    init(searchUsersUseCase: SearchUsersUseCase) {
        self.searchUsersUseCase = searchUsersUseCase
    }
    
    private func triggerDebouncedSearch() {
        searchTask?.cancel()
        
        let cleanQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanQuery.isEmpty else {
            self.searchState = .idle
            self.uiState.data = []
            return
        }
        
        searchTask = Task {
            do {
                try await Task.sleep(for: .seconds(0.3))

                guard !Task.isCancelled else { return }
                
                self.searchState = .loading
                self.isLoading = true
                self.errorMessage = nil
                
                let users = try await searchUsersUseCase(query: cleanQuery, roleClient: nil)
                
                guard !Task.isCancelled else { return }

                self.uiState.data = users
                self.isLoading = false
                
                if users.isEmpty {
                    self.searchState = .empty
                } else {
                    self.searchState = .success(users)
                }
                
            } catch is CancellationError {
            } catch {
                guard !Task.isCancelled else { return }
                self.isLoading = false
                let friendlyError = error.localizedDescription
                self.errorMessage = friendlyError
                self.searchState = .error(friendlyError)
            }
        }
    }

    func performInstantSearch() {
        searchTask?.cancel()
        triggerDebouncedSearch()
    }
}
