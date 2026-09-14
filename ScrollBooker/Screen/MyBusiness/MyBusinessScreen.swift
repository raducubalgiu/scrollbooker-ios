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
        route: .myDashboard
    ),

    MyBusinessPage(
        title: String(localized: "my_business_unapproved"),
        description: String(localized: "my_business_unapproved_description"),
        icon: "building.2",
        route: .unapprovedBusinesses
    ),

    MyBusinessPage(
        title: String(localized: "my_business_details"),
        description: String(localized: "my_business_details_description"),
        icon: "location",
        route: .myBusinessDetails
    ),

    MyBusinessPage(
        title: String(localized: "my_business_schedule"),
        description: String(localized: "my_business_schedule_description"),
        icon: "clock",
        route: .mySchedules
    ),

    MyBusinessPage(
        title: String(localized: "my_business_services"),
        description: String(localized: "my_business_services_description"),
        icon: "bag",
        route: .myProducts
    ),

    MyBusinessPage(
        title: String(localized: "my_business_categories"),
        description: String(localized: "my_business_categories_description"),
        icon: "book.closed",
        route: .myServices
    ),

    MyBusinessPage(
        title: String(localized: "my_business_calendar"),
        description: String(localized: "my_business_calendar_description"),
        icon: "calendar",
        route: .myCalendar
    ),

    MyBusinessPage(
        title: String(localized: "my_business_employees"),
        description: String(localized: "my_business_employees_description"),
        icon: "person.2",
        route: .myEmployees
    ),
]

struct MyBusinessScreen: View {
    var onNavigate: (Route) -> Void
    var onBack: () -> Void

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
                ForEach(myBusinessPages) { page in
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
}
