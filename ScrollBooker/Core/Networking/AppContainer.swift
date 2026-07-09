//
//  AppContainer.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.09.2025.
//

import Foundation
import SwiftUI

@MainActor
final class AppContainer: ObservableObject, AppContainerProtocol {
    let session: SessionManager
    let apiClient: APIClient

    let userProfileModule: UserProfileModule
    let appointmentModule: AppointmentModule
    let notificationModule: NotificationModule
    let problemModule: ProblemModule
    let followModule: FollowModule
    let userAPI: UserAPI

    init() {
        self.apiClient = APIClient(config: .default)
        self.session = SessionManager(client: apiClient)
        
        self.userProfileModule = UserProfileModule(apiClient: apiClient)
        self.appointmentModule = AppointmentModule(apiClient: apiClient)
        self.notificationModule = NotificationModule(apiClient: apiClient)
        self.problemModule = ProblemModule(apiClient: apiClient)
        self.followModule = FollowModule(apiClient: apiClient)
        self.userAPI = UserAPIImpl(client: apiClient)
    }
    
    func bootstrap() async {
        let authInterceptor = AuthInterceptor(sessionManager: session)
        await apiClient.addInterceptor(authInterceptor)
    }
}

