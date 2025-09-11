//
//  CollectLocationPermissionViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.09.2025.
//

import Foundation

@MainActor
@Observable
final class CollectLocationPermissionViewModel: HasLoadingState {
    private let api: OnboardingAPI
    private let session: SessionManager
    
    var isLoading = false
    var errorMessage: String?
    
    init(api: OnboardingAPI, session: SessionManager) {
        self.api = api
        self.session = session
    }
    
    func collectLocationPermission() async {
        try? await withVisibleLoading {
            guard let token = session.auth.accessToken, !token.isEmpty else {
                errorMessage = "Missing access token."
                return
            }
            
            let authState = try await api.collectLocationPermission(token: token)
            print("AUTH STATE!!!", authState)
        }
    }
}
