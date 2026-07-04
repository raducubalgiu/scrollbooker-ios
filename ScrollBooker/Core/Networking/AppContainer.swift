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
    let session: SessionManager
    let apiClient: APIClient
    
    let getUserAppointmentsUseCase: GetUserAppointmentsUseCase
    
    // MARK: - Modulele vechi (Până la refactorizarea lor)
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
        Task.detached { await client.addInterceptor(authInterceptor) }

        self.getUserAppointmentsUseCase = GetUserAppointmentsUseCaseImpl(
            repository: AppointmentRepositoryImpl(
                api: AppointmentAPIImpl(client: client)
            )
        )
        
        self.notificationAPI = NotificationAPIImpl(client: client)
        self.onboardingAPI = OnboardingAPIImpl(client: client)
        self.userAPI = UserAPIImpl(client: client)
        self.userProfileAPI = UserProfileAPIImpl(client: client)
    }
    
    func makeCollectUsernameViewModel() -> CollectUsernameViewModel {
        CollectUsernameViewModel(api: onboardingAPI, session: session)
    }
    
    func makeAppointmentsViewModel() -> AppointmentsViewModel {
        AppointmentsViewModel(getUserAppointmentsUseCase: getUserAppointmentsUseCase)
    }
}
