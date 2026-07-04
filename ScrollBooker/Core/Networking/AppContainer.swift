//
//  AppContainer.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.09.2025.
//

import Foundation
import SwiftUI

@MainActor
final class AppContainer: ObservableObject {
    // Servicii Core globale
    let session: SessionManager
    let apiClient: APIClient
    
    // APIs declarate direct ca proprietăți imutabile (eliminăm `lazy var` pentru thread-safety la inițializare)
    let appointmentAPI: AppointmentAPI
    let notificationAPI: NotificationAPI
    let onboardingAPI: OnboardingAPI
    let userAPI: UserAPI
    let userProfileAPI: UserProfileAPI
    
    init() {
        let client = APIClient(config: .default)
        let sessionManager = SessionManager(client: client)
        
        self.apiClient = client
        self.session = sessionManager
        
        let authInterceptor = AuthInterceptor(sessionManager: sessionManager)
        Task.detached {
            // Rupem legătura cu @MainActor. Această linie va rula direct pe un thread secundar de background,
            // permițând APIClient-ului și rețelei să funcționeze instant, fără să mai agațe interfața grafică.
            await client.addInterceptor(authInterceptor)
        }
        
        // Inițializăm API-urile direct. Fiind structuri ușoare, nu blochează thread-ul principal (UI)
        self.appointmentAPI = AppointmentAPIImpl(client: client)
        self.notificationAPI = NotificationAPIImpl(client: client)
        self.onboardingAPI = OnboardingAPIImpl(client: client)
        self.userAPI = UserAPIImpl(client: client)
        self.userProfileAPI = UserProfileAPIImpl(client: client)
    }
    
    // MARK: - View Model Factories (Rămân neschimbate și curate)
    func makeCollectUsernameViewModel() -> CollectUsernameViewModel {
        CollectUsernameViewModel(api: onboardingAPI, session: session)
    }
    
    func makeAppointmentsViewModel() -> AppointmentsViewModel {
        AppointmentsViewModel(api: appointmentAPI, session: session)
    }
}
