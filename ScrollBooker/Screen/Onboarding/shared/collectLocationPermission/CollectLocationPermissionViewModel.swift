//
//  CollectLocationPermissionViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.09.2025.
//

import Foundation
import Observation

@MainActor // Garantează modificarea stării de UI exclusiv pe Thread-ul Principal
@Observable
final class CollectLocationPermissionViewModel: HasLoadingState {
    
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
    /// Trimite confirmarea permisiunii de locație către server pentru a avansa în fluxul de onboarding.
    func collectLocationPermission() async {
        // Resetăm mesajul de eroare la începutul unei noi acțiuni
        errorMessage = nil
        
        do {
            // SOLUȚIE ENTERPRISE: Am eliminat blocul try? care ascundea erorile de rețea.
            // Am eliminat codul parazit de verificare și pasare manuală a token-ului.
            try await withVisibleLoading {
                let authState = try await api.collectLocationPermission()
                print("Successfully updated location permission state. New Auth State:", authState)
                
                // Sfat Enterprise: Actualizarea stării globale a sesiunii de onboarding
                // await session.updateAuthState(authState)
            }
        } catch {
            // GESTIONARE ERORI ENTERPRISE: Dacă pică conexiunea sau serverul refuză cererea, utilizatorul primește feedback.
            if let localizedError = error as? LocalizedError {
                errorMessage = localizedError.errorDescription
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }
}
