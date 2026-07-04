//
//  CollectGenderViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.09.2025.
//

import Foundation
import Observation

@MainActor // Garantează modificarea stării de UI exclusiv pe Thread-ul Principal
@Observable
final class CollectGenderViewModel: HasLoadingState {
    
    // MARK: - Dependencies
    private let api: OnboardingAPI
    private let session: SessionManager
    
    // MARK: - UI State
    var isLoading = false
    var errorMessage: String?
    
    // MARK: - Init
    init(api: OnboardingAPI, session: SessionManager) {
        self.api = api
        self.session = session
    }
    
    // MARK: - Actions
    /// Trimite genul selectat din interfață către server.
    func collectGender(gender: GenderEnum) async {
        // Resetăm mesajul de eroare la inițierea unei noi acțiuni
        errorMessage = nil
        
        do {
            // SOLUȚIE ENTERPRISE: Am eliminat blocul generic try? care înghițea erorile de sistem.
            // Am eliminat extragerea manuală de token; AuthInterceptor va injecta automat header-ul necesar.
            try await withVisibleLoading {
                let authState = try await api.collectGender(gender: gender.rawValue)
                print("Successfully collected gender. New Auth State:", authState)
                
                // Sfat Enterprise: Actualizarea stării globale a sesiunii de onboarding
                // await session.updateAuthState(authState)
            }
        } catch {
            // GESTIONARE ERORI ENTERPRISE: Capturăm și mapăm orice eroare (ex: validare server sau picat internetul)
            if let localizedError = error as? LocalizedError {
                errorMessage = localizedError.errorDescription
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }
}
