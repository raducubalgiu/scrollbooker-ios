//
//  MyBusinessScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

private var myBusinessPages = [
    MyBusinessPage(
        title: String(localized: "my_business_dashboard"),
        description: String(localized: "my_business_dashboard_description"),
        icon: "square.grid.2x2",
        route: .myDashboard,
        permission: .myDashboardView
    ),

    MyBusinessPage(
        title: String(localized: "my_business_unapproved"),
        description: String(localized: "my_business_unapproved_description"),
        icon: "building.2",
        route: .unapprovedBusinesses,
        permission: .nomenclaturesView
    ),

    MyBusinessPage(
        title: String(localized: "my_business_details"),
        description: String(localized: "my_business_details_description"),
        icon: "location",
        route: .myBusinessDetails,
        permission: .myBusinessLocationView
    ),

    MyBusinessPage(
        title: String(localized: "my_business_schedule"),
        description: String(localized: "my_business_schedule_description"),
        icon: "clock",
        route: .mySchedules,
        permission: .mySchedulesView
    ),
    
    MyBusinessPage(
        title: String(localized: "my_business_categories"),
        description: String(localized: "my_business_categories_description"),
        icon: "book.closed",
        route: .myServices,
        permission: .myServicesView
    ),

    MyBusinessPage(
        title: String(localized: "my_business_services"),
        description: String(localized: "my_business_services_description"),
        icon: "bag",
        route: .myProducts,
        permission: .myProductsView
    ),

    MyBusinessPage(
        title: String(localized: "my_business_calendar"),
        description: String(localized: "my_business_calendar_description"),
        icon: "calendar",
        route: .myCalendar,
        permission: .myCalendarView
    ),

    MyBusinessPage(
        title: String(localized: "my_business_employees"),
        description: String(localized: "my_business_employees_description"),
        icon: "person.2",
        route: .myEmployees,
        permission: .myEmployeesView
    ),
]

struct MyBusinessScreen: View {
    var onNavigate: (Route) -> Void
    var onBack: () -> Void

    @Environment(SessionManager.self) private var session

    private var isEmployee: Bool {
        guard let userInfo = session.userInfo, let businessOwnerId = userInfo.businessOwnerId else {
            return false
        }
        return userInfo.id != businessOwnerId
    }

    private var visiblePages: [MyBusinessPage] {
        myBusinessPages.filter { page in
            switch page.permission {
            case .myEmployeesView:
                guard session.userInfo?.hasEmployees == true else { return false }
            case .mySchedulesView:
                guard isEmployee else { return false }
            default:
                break
            }

            return session.hasPermission(page.permission)
        }
    }

    var body: some View {
        HeaderView(
            title: String(localized: "my_business_title"),
            onBack: onBack
        )

        let columns = [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ]

        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(visiblePages) { page in
                    MyBusinessCardView(
                        title: page.title,
                        description: page.description,
                        icon: page.icon,
                        onClick: { onNavigate(page.route) }
                    )
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    }
}

struct MyBusinessPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let route: Route
    let permission: PermissionEnum
}
