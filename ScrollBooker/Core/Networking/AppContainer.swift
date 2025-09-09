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
    // MARK: - Core services
    let session: SessionManager
    let apiClient: APIClient
    
    // MARK: - APIs
    lazy var appointmentAPI: AppointmentAPI = AppointmentAPIImpl(client: apiClient)
    lazy var notificationAPI: NotificationAPI = NotificationAPIImpl(client: apiClient)
    lazy var onboardingAPI: OnboardingAPI = OnboardingAPIImpl(client: apiClient)
    
    // MARK: - Init
    init() {
        let client = APIClient(config: .default)
        
        self.apiClient = client
        self.session = SessionManager(client: client)
    }
    
    // MARK: - View Model factories
    func makeAppointmentsViewModel() -> AppointmentsViewModel {
        AppointmentsViewModel(api: appointmentAPI, session: session)
    }
    
    func makeCollectUsernameViewModel() -> CollectUsernameViewModel {
        CollectUsernameViewModel(api: onboardingAPI, session: session)
    }
}
