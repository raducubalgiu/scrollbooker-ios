//
//  MyBusinessScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

private var myBusinessPages = [
    MyBusinessPage(
        title: String(localized: "location"),
        description: String(localized: "businessLocationDetails"),
        icon: "location",
        route: .mySchedules
    ),
    MyBusinessPage(
        title: String(localized: "scheduleShort"),
        description: String(localized: "userScheduleDetails"),
        icon: "clock",
        route: .mySchedules
    ),
    MyBusinessPage(
        title: String(localized: "products"),
        description: String(localized: "userProductsDetails"),
        icon: "bag",
        route: .myProducts
    ),
    MyBusinessPage(
        title: String(localized: "services"),
        description: String(localized: "servicesDetails"),
        icon: "bag",
        route: .myServices
    ),
    MyBusinessPage(
        title: String(localized: "calendar"),
        description: "Detalii despre produsele mele",
        icon: "calendar",
        route: .myCalendar
    ),
    MyBusinessPage(
        title: "Valute",
        description: String(localized: "paymentMethodsDetails"),
        icon: "creditcard",
        route: .myCurrencies
    ),
    MyBusinessPage(
        title: String(localized: "employees"),
        description: "Detalii despre angajatii tai",
        icon: "person.2",
        route: .myEmployees
    ),
    MyBusinessPage(
        title: String(localized: "employmentRequests"),
        description: "Detalii despre angajatii tai",
        icon: "repeat",
        route: .myEmploymentRequests
    )
]

struct MyBusinessScreen: View {
    var onNavigate: (Route) -> Void
    
    var body: some View {
        Header(title: "Afacerea mea")
        
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

#Preview("Light") {
    MyBusinessScreen(
        onNavigate: { _ in }
    )
}

#Preview("Dark") {
    MyBusinessScreen(
        onNavigate: { _ in }
    )
        .preferredColorScheme(.dark)
}
