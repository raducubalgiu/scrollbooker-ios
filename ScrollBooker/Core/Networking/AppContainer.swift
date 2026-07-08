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

    // MARK: - Feature Modules
    let appointmentModule: AppointmentModule
    let notificationModule: NotificationModule

    // MARK: - Legacy APIs
    let userAPI: UserAPI

    init() {
        apiClient = APIClient(config: .default)
        session = SessionManager(client: apiClient)

        let authInterceptor = AuthInterceptor(sessionManager: session)

        let client = apiClient
        Task.detached {
            await client.addInterceptor(authInterceptor)
        }

        appointmentModule = AppointmentModule(apiClient: apiClient)
        notificationModule = NotificationModule(apiClient: apiClient)

        // MARK: - Legacy
        userAPI = UserAPIImpl(client: apiClient)
    }
}
