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

    let bookingFlowModule: BookingFlowModule
    let businessDomainModule: BusinessDomainModule
    let businessModule: BusinessModule
    let productModule: ProductModule
    let scheduleModule: ScheduleModule
    let consentModule: ConsentModule
    let professionModule: ProfessionModule
    let searchModule: SearchModule
    let employeesModule: EmployeesModule
    let employmentRequestModule: EmploymentRequestModule
    let servieDomainModule: ServiceDomainModule
    let reviewModule: ReviewModule
    let userProfileModule: UserProfileModule
    let appointmentModule: AppointmentModule
    let notificationModule: NotificationModule
    let problemModule: ProblemModule
    let followModule: FollowModule
    let userAPI: UserAPI

    init() {
        self.apiClient = APIClient(config: .default)
        self.session = SessionManager(client: apiClient)
        
        self.bookingFlowModule = BookingFlowModule(apiClient: apiClient)
        self.businessDomainModule = BusinessDomainModule(apiClient: apiClient)
        self.businessModule = BusinessModule(apiClient: apiClient)
        self.productModule = ProductModule(apiClient: apiClient)
        self.scheduleModule = ScheduleModule(apiClient: apiClient)
        self.consentModule = ConsentModule(apiClient: apiClient)
        self.professionModule = ProfessionModule(apiClient: apiClient)
        self.searchModule = SearchModule(apiClient: apiClient)
        self.employeesModule = EmployeesModule(apiClient: apiClient)
        self.employmentRequestModule = EmploymentRequestModule(apiClient: apiClient)
        self.servieDomainModule = ServiceDomainModule(apiClient: apiClient)
        self.reviewModule = ReviewModule(apiClient: apiClient)
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

