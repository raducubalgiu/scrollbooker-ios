//
//  CollectUserUsernameViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.09.2025.
//

import Foundation

@Observable
final class CollectUsernameViewModel {
    private let api: OnboardingAPI
    private let session: SessionManager
    
    var username: String = ""
    var isLoading: Bool = false
    var isAvailable: Bool = false
    var suggestions: [String] = []
    var errorMessage: String?
    
    private var searchTask: Task<Void, Never>?
    
    init(api: OnboardingAPI, session: SessionManager) {
        self.api = api
        self.session = session
    }
    
    deinit {
        searchTask?.cancel()
    }
    
    // Apeleaza cand se modifica textul. Face debounce (300 ms)
    @MainActor
    func onUsernameChanged(_ newValue: String) async {
        username = newValue
        
        guard newValue.count >= 3 else {
            searchTask?.cancel()
            isAvailable = false
            suggestions = []
            errorMessage = nil
            isLoading = false
            return
        }
        
        // anulam taskul precedent si programam unul nou
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            guard let self else { return }
            // debounce window
            try? await Task.sleep(nanoseconds: 300_000_000)
            
            // daca intre timp s-a scris altceva, iesim
            if Task.isCancelled { return }
            await self.performSearch(for: newValue)
        }
    }
    
    @MainActor
    private func performSearch(for value: String) async {
        guard let token = session.auth.accessToken, !token.isEmpty else {
            errorMessage = "Missing access token."
            return
        }
        
        let start = ContinuousClock.now
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await api.searchUsername(username: value, token: token)
            
            // daca intre timp s-a introdus alt text, ignoram rezultatul
            guard value == username else { return }
            
            isAvailable = response.available
            suggestions = response.suggestions
            errorMessage = nil
        } catch {
            // daca userul a tastat altceva si s-a pornit alt task, nu suprascriem
            guard value == username else { return }
            
            errorMessage = error.localizedDescription
            isAvailable = false
            suggestions = []
        }
        
        let elapsed = start.duration(to: .now)
        if elapsed < .milliseconds(300) {
            try? await Task.sleep(for: .milliseconds(300) - elapsed)
        }
    }
}
