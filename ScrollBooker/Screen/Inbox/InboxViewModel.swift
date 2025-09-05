//
//  InboxViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation

@MainActor
final class InboxViewModel: ObservableObject {
    @Published private(set) var notifications: [Notification] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isRefreshing: Bool = false
    @Published var errorMessage: String?
    
    @Published var isInitialLoading = false
    private var didInitialLoading = false
    
    private let api: NotificationAPI
    private let session: SessionManager
    
    private var page = 1
    private let limit = 20
    private var count = 0
    
    var hasMore: Bool { notifications.count < count }
    
    init(api: NotificationAPI, session: SessionManager) {
        self.api = api
        self.session = session
    }
    
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
        
//        guard notifications.isEmpty && !isLoading else { return }
//        await refresh()
    }
    
    func refresh() async {
        guard !isLoading else { return }
        isRefreshing = true
        page = 1
        count = 0
        notifications.removeAll()
        await loadNextPage()
        isRefreshing = false
    }
    
    func loadMoreIfNeeded(currentNotification notification: Notification?) async {
        guard !isLoading, hasMore else { return }
        guard let notification, notification.id == notifications.last?.id else { return }
        await loadNextPage()
    }
    
    private func loadNextPage() async {
        guard let token = session.auth.accessToken, !token.isEmpty else {
            errorMessage = "Missing access token."
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let pageData = try await api.fetch(page: page, limit: limit, bearer: token)
            count = pageData.count
            notifications.append(contentsOf: pageData.results)
            page += 1
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
