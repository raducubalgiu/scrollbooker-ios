//
//  AppContainer.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.09.2025.
//

import Foundation
import Observation

@Observable
@MainActor
final class AppContainer {
    let session: SessionManager
    let apiClient: APIClient

    let authModule: AuthModule
    let userInfoModule: UserInfoModule
    let userPermissionsModule: UserPermissionsModule
    let cloudflareModuke: CloudflareModule
    let commentModule: CommentModule
    let postModule: PostModule
    let availabilityModule: AvailabilityModule
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
    let dashboardModule: DashboardModule

    init() {
        self.apiClient = APIClient(config: .default)

        let authStore = AuthStore()
        let userInfoModule = UserInfoModule(apiClient: apiClient)
        let userPermissionsModule = UserPermissionsModule(apiClient: apiClient)
        let authModule = AuthModule(
            apiClient: apiClient,
            store: authStore,
            getUserInfoUseCase: userInfoModule.getUserInfoUseCase,
            getUserPermissionsUseCase: userPermissionsModule.getUserPermissionsUseCase
        )
        self.authModule = authModule
        self.userInfoModule = userInfoModule
        self.userPermissionsModule = userPermissionsModule
        self.session = SessionManager(
            store: authStore,
            loginUseCase: authModule.loginUseCase,
            registerUseCase: authModule.registerUseCase,
            refreshSessionUseCase: authModule.refreshSessionUseCase,
            verifyEmailUseCase: authModule.verifyEmailUseCase,
            saveSessionUseCase: authModule.saveSessionUseCase,
            isLoggedInUseCase: authModule.isLoggedInUseCase
        )

        self.cloudflareModuke = CloudflareModule(apiClient: apiClient)
        self.commentModule = CommentModule(apiClient: apiClient)
        self.postModule = PostModule(apiClient: apiClient)
        self.availabilityModule = AvailabilityModule(apiClient: apiClient)
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
        self.dashboardModule = DashboardModule(apiClient: apiClient)
    }
    
    func bootstrap() async {
        let authInterceptor = AuthInterceptor(sessionManager: session)
        await apiClient.addInterceptor(authInterceptor)
    }
}

