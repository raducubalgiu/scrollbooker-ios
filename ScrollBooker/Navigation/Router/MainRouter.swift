//
//  MainRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct MainRouter: View {
    @State private var router = Router()
    @Environment(SessionManager.self) private var session
    @Environment(AppContainer.self) private var container

    var body: some View {
        ZStack {
            FeedTabRouter(router: router)
                .opacity(router.selectedTab == .feed ? 1 : 0)
                .zIndex(router.selectedTab == .feed ? 1 : 0)
            
            InboxTabRouter(router: router)
                .opacity(router.selectedTab == .inbox ? 1 : 0)
                .zIndex(router.selectedTab == .inbox ? 1 : 0)
            
            SearchTabRouter(router: router)
                .opacity(router.selectedTab == .search ? 1 : 0)
                .zIndex(router.selectedTab == .search ? 1 : 0)
            
            AppointmentsTabRouter(router: router)
                .opacity(router.selectedTab == .appointments ? 1 : 0)
                .zIndex(router.selectedTab == .appointments ? 1 : 0)
            
            ProfileTabRouter(router: router)
                .opacity(router.selectedTab == .profile ? 1 : 0)
                .zIndex(router.selectedTab == .profile ? 1 : 0)
        }
        .environment(router)
        .task {
            async let appointments = try? container.appointmentModule.getUserAppointmentsNumberUseCase()
            async let notifications = try? container.notificationModule.getUserNotificationsNumberUseCase()
            let (appointmentsCount, notificationsCount) = await (appointments, notifications)

            router.appointmentsCount = appointmentsCount ?? 0
            router.notificationsCount = notificationsCount ?? 0
        }
    }
}
