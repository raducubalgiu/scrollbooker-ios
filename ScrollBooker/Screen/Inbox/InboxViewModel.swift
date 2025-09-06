//
//  InboxViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation

@MainActor
final class InboxViewModel: ObservableObject, HasLoadingState {
    // MARK: - State (conform Has Loading State)
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - UI State
    @Published private(set) var isRefreshing: Bool = false
    @Published var isInitialLoading = false
    private var didInitialLoading = false
    
    @Published private(set) var notifications: [Notification] = []
    
    // MARK: - Deps
    private let api: NotificationAPI
    private let session: SessionManager
    
    // MARK: - Paging
    private var page = 1
    private let limit = 20
    private var count = 0
    var hasMore: Bool { notifications.count < count }
    
    init(api: NotificationAPI, session: SessionManager) {
        self.api = api
        self.session = session
    }
    
    // MARK: - Public
    func initialLoadIfNeeded() async {
        guard !didInitialLoading else { return }
        isInitialLoading = true
        
        defer {
            isInitialLoading = false
            didInitialLoading = true
        }
        notifications.removeAll()
        page = 1
        await loadNextPage()
    }
    
    func refresh() async {
        guard !isLoading else { return }
        isRefreshing = true
        defer { isRefreshing = false }
        
        notifications.removeAll()
        page = 1
        await loadNextPage()
    }
    
    func loadMoreIfNeeded(currentNotification: Notification?) async {
        guard !isLoading, hasMore else { return }
        guard let current = currentNotification,
              current.id == notifications.last?.id else { return }
        
        await loadNextPage()
    }
    
    func delete(_ notification: Notification) async {
        guard let token = session.auth.accessToken, !token.isEmpty else {
            errorMessage = "Missing access token."; return
        }
        guard let idx = notifications.firstIndex(where: { $0.id == notification.id }) else { return }
        
        // optimistic UI
        let removed = notifications.remove(at: idx)
                
        do {
            try await withVisibleLoading {
                try await api.deleteNotificationById(notificationId: removed.id, bearer: token)
            }
        } catch {
            // rollback
            notifications.insert(removed, at: idx)
        }
    }
    
    private func loadNextPage() async {
        guard let token = session.auth.accessToken, !token.isEmpty else {
            errorMessage = "Missing access token."
            return
        }
        
        do {
            let response: PaginatedResponse<Notification> = try await withVisibleLoading {
                try await api.getNotifications(
                    page: page,
                    limit: limit,
                    bearer: token
                )
            }
            count = response.count
            notifications.append(contentsOf: response.results)
            page += 1
        } catch {
            
        }
    }
}
