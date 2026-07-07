//
//  InboxViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation

//@MainActor
//final class InboxViewModel: ObservableObject, HasLoadingState {
//    // MARK: - State (conform Has Loading State)
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String?
//    
//    // MARK: - UI State
//    @Published private(set) var isRefreshing: Bool = false
//    @Published var isInitialLoading = false
//    private var didInitialLoading = false
//    
//    @Published private(set) var notifications: [Notification] = []
//    
//    // MARK: - Deps
//    private let api: NotificationAPI
//    private let session: SessionManager
//    
//    // MARK: - Paging
//    private var page = 1
//    private let limit = 20
//    private var count = 0
//    var hasMore: Bool { notifications.count < count }
//    
//    init(api: NotificationAPI, session: SessionManager) {
//        self.api = api
//        self.session = session
//    }
//    
//    // MARK: - Public
//    func initialLoadIfNeeded() async {
//        guard !didInitialLoading else { return }
//        isInitialLoading = true
//        
//        defer {
//            isInitialLoading = false
//            didInitialLoading = true
//        }
//        notifications.removeAll()
//        page = 1
//        await loadNextPage()
//    }
//    
//    func refresh() async {
//        guard !isLoading else { return }
//        isRefreshing = true
//        defer { isRefreshing = false }
//        
//        notifications.removeAll()
//        page = 1
//        await loadNextPage()
//    }
//    
//    func loadMoreIfNeeded(currentNotification: Notification?) async {
//        guard !isLoading, hasMore else { return }
//        guard let current = currentNotification,
//              current.id == notifications.last?.id else { return }
//        
//        await loadNextPage()
//    }
//    
//    func delete(_ notification: Notification) async {
//        // SOLUȚIE ENTERPRISE: Am eliminat verificarea manuală a token-ului.
//        errorMessage = nil
//        
//        guard let idx = notifications.firstIndex(where: { $0.id == notification.id }) else { return }
//        
//        // Optimistic UI (Aplicația șterge notificarea instant din UI pentru un efect de fluiditate maximă)
//        let removed = notifications.remove(at: idx)
//                
//        do {
//            try await withVisibleLoading {
//                // Apel curat, interceptorul se ocupă de securitate în background
//                try await api.deleteNotificationById(notificationId: removed.id)
//            }
//        } catch {
//            // Rollback (Dacă serverul dă eroare, reintroducem notificarea exact pe poziția ei inițială)
//            notifications.insert(removed, at: idx)
//            
//            if let localizedError = error as? LocalizedError {
//                errorMessage = localizedError.errorDescription
//            } else {
//                errorMessage = error.localizedDescription
//            }
//        }
//    }
//    
//    private func loadNextPage() async {
//        // Am eliminat codul parazit de token checking
//        errorMessage = nil
//        
//        do {
//            let response: PaginatedResponse<Notification> = try await withVisibleLoading {
//                // Apel curat fără parametrul bearer
//                try await api.getNotifications(page: page, limit: limit)
//            }
//            count = response.count
//            notifications.append(contentsOf: response.results)
//            page += 1
//        } catch {
//            // Gestionăm eroarea de rețea sau de sesiune pentru paginare
//            if let localizedError = error as? LocalizedError {
//                errorMessage = localizedError.errorDescription
//            } else {
//                errorMessage = error.localizedDescription
//            }
//        }
//    }
//}
