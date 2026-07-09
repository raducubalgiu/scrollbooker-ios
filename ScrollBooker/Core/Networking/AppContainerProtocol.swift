//
//  AppContainerProtocol.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

@MainActor
protocol AppContainerProtocol {
    var session: SessionManager { get }
    var apiClient: APIClient { get }
    var appointmentModule: AppointmentModule { get }
    var notificationModule: NotificationModule { get }
    var problemModule: ProblemModule { get }
    var userAPI: UserAPI { get }
    
    func bootstrap() async
}
