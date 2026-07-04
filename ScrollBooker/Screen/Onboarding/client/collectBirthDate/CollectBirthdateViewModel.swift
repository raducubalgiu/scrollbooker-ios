//
//  CollectBirthdateViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.09.2025.
//

import Foundation
import Observation

@MainActor // Garantează că toate modificările proprietăților de UI se fac strict pe Thread-ul Principal
@Observable
final class CollectBirthdateViewModel: HasLoadingState {
    
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
    /// Trimite data de naștere colectată din UI către server.
    func collectBirthdate(birthdate: String?) async {
        // Resetăm eroarea anterioară înainte de a porni un nou request
        errorMessage = nil
        
        do {
            // SOLUȚIE ENTERPRISE: Am înlocuit operatorul "try?" (care ascundea erorile) cu un bloc "do-catch" nativ.
            // Apelul nu mai conține argumentul `token: token`. Interceptorul global injectează automat sesiunea corectă.
            try await withVisibleLoading {
                let authState = try await api.collectBirthdate(birthdate: birthdate)
                print("Successfully collected birthdate. New Auth State:", authState)
                
                // Sfat Enterprise: Aici vei propaga de obicei noul stadiu de înregistrare în sesiune
                // await session.updateAuthState(authState)
            }
        } catch {
            // GESTIONARE CORECTĂ A ERORILOR: Dacă serverul respinge data sau pică rețeaua, utilizatorul primește feedback în UI.
            if let localizedError = error as? LocalizedError {
                errorMessage = localizedError.errorDescription
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }
}
