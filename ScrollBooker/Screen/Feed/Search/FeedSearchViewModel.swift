//
//  FeedSearchViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class FeedSearchViewModel {
    private(set) var searchState: FeatureState<[SearchUser]> = .idle
    
    var searchText: String = "" {
        didSet {
            triggerDebouncedSearch()
        }
    }
    private var lastSearchedQuery: String = ""
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "FeedSearch")
    
    private let searchUsersUseCase: SearchUsersUseCase
    private var searchTask: Task<Void, Never>? = nil
    
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

                let users = try await withLoading {
                    try await searchUsersUseCase(query: cleanQuery, roleClient: nil)
                }
                
                guard !Task.isCancelled else { return }
                self.lastSearchedQuery = cleanQuery

                self.searchState = .success(users)
                
            } catch is CancellationError {
 
            } catch {
                guard !Task.isCancelled else { return }
                
                logger.error("ERROR: on Searching Feed Users (\(cleanQuery)): \(error.localizedDescription)")
                self.searchState = .error("Something went wrong")
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

