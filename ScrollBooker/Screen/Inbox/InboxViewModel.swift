//
//  InboxViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation
import Observation

enum InboxState: Equatable {
    case idle
    case loading
    case empty
    case success([Notification])
    case error(String)
}

@Observable
@MainActor
final class InboxViewModel: HasLoadingState {
    var uiState = UiState(data: [Notification]())
    
    private(set) var viewState: InboxState = .idle
    private(set) var isPaging: Bool = false
    private(set) var isRefreshing: Bool = false

    private let getUserNotifications: GetUserNotificationsUseCase
    private var page = 1
    private let limit = 20
    private var totalCount = 0

    var hasMore: Bool {
        uiState.data.count < totalCount
    }

    var isLoading: Bool {
        get { if case .loading = viewState { return true }; return false }
        set { if newValue { viewState = .loading } }
    }

    var errorMessage: String? {
        get { if case .error(let msg) = viewState { return msg }; return nil }
        set { if let msg = newValue { viewState = .error(msg) } }
    }

    init(getUserNotifications: GetUserNotificationsUseCase) {
        self.getUserNotifications = getUserNotifications
    }

    func initialLoadIfNeeded() async {
        guard uiState.data.isEmpty else { return }
        await load(isFirstPage: true)
    }

    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        page = 1
        await load(isFirstPage: true)
        isRefreshing = false
    }

    func loadMoreIfNeeded(currentNotification: Notification?) async {
        guard hasMore, !isPaging, !isRefreshing, !isLoading else { return }

        guard let current = currentNotification,
              current.id == uiState.data.last?.id
        else { return }

        isPaging = true
        await load(isFirstPage: false)
        isPaging = false
    }

    private func load(isFirstPage: Bool) async {
        if isFirstPage && !isRefreshing {
            viewState = .loading
        }

        do {
            let response = try await getUserNotifications(page: page, limit: limit)

            if isFirstPage {
                uiState.data = response.results
            } else {
                let existingIds = Set(uiState.data.map(\.id))
                let unique = response.results.filter { !existingIds.contains($0.id) }
                uiState.data.append(contentsOf: unique)
            }

            totalCount = response.count
            page += 1

            if uiState.data.isEmpty {
                viewState = .empty
            } else {
                viewState = .success(uiState.data)
            }

        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription

            if isFirstPage {
                viewState = .error(message)
            } else {
                print("Eroare la încărcarea paginii următoare din Inbox: \(message)")
            }
        }
    }
}
