//
//  CollectUsernameViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class CollectUsernameViewModel {
    private let session: SessionManager
    private let collectUserUsernameUseCase: CollectUserUsernameUseCase
    private let searchUsernameUseCase: SearchUsernameUseCase
    private let getUserInfoUseCase: GetUserInfoUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Onboarding")

    private(set) var searchState: FeatureState<SearchUsername> = .idle
    var isSaving = false
    var saveError: String?

    var username: String = "" {
        didSet {
            triggerDebouncedSearch()
        }
    }
    private var lastSearchedUsername: String = ""
    private var searchTask: Task<Void, Never>?

    var isSubmitEnabled: Bool {
        guard case .success(let result) = searchState else { return false }
        return result.available && result.username == username && username.count >= 3 && !isSaving
    }

    init(
        session: SessionManager,
        collectUserUsernameUseCase: CollectUserUsernameUseCase,
        searchUsernameUseCase: SearchUsernameUseCase,
        getUserInfoUseCase: GetUserInfoUseCase
    ) {
        self.session = session
        self.collectUserUsernameUseCase = collectUserUsernameUseCase
        self.searchUsernameUseCase = searchUsernameUseCase
        self.getUserInfoUseCase = getUserInfoUseCase
    }

    private func triggerDebouncedSearch() {
        searchTask?.cancel()

        guard username.count >= 3 else {
            searchState = .idle
            lastSearchedUsername = ""
            return
        }

        guard username != lastSearchedUsername else { return }

        searchTask = Task {
            do {
                try await Task.sleep(for: .seconds(0.2))

                guard !Task.isCancelled else { return }
                searchState = .loading

                let result = try await withLoading {
                    try await searchUsernameUseCase(username: username)
                }

                guard !Task.isCancelled else { return }
                lastSearchedUsername = username

                searchState = .success(result)
            } catch is CancellationError {

            } catch {
                guard !Task.isCancelled else { return }
                searchState = .error(logger.userMessage(for: error, context: "Searching Username (\(username))"))
                lastSearchedUsername = ""
            }
        }
    }

    func collectUsername() async {
        isSaving = true
        saveError = nil

        do {
            let freshUserInfo = try await withLoading {
                _ = try await self.collectUserUsernameUseCase(username: self.username)
                return try await self.getUserInfoUseCase()
            }
            session.setAuthenticated(freshUserInfo)
        } catch {
            saveError = logger.userMessage(for: error, context: "Collecting Username")
        }

        isSaving = false
    }
}
