//
//  MyBusinessScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

private var myBusinessPages = [
    MyBusinessPage(
        title: "Locatie",
        description: "Detalii despre locatia business-ului tau",
        icon: "location",
        route: .mySchedules
    ),
    MyBusinessPage(
        title: "Program",
        description: "Detalii despre programul meu",
        icon: "clock",
        route: .mySchedules
    ),
    MyBusinessPage(
        title: "Produse",
        description: "Detalii despre produsele mele",
        icon: "bag",
        route: .myProducts
    ),
    MyBusinessPage(
        title: "Servicii",
        description: "Detalii despre serviciile tale",
        icon: "bag",
        route: .myServices
    ),
    MyBusinessPage(
        title: "Calendar",
        description: "Detalii despre produsele mele",
        icon: "calendar",
        route: .myCalendar
    ),
    MyBusinessPage(
        title: "Valute",
        description: "Alege valutele acceptate pentru plata",
        icon: "creditcard",
        route: .myCurrencies
    ),
    MyBusinessPage(
        title: "Angajati",
        description: "Detalii despre angajatii tai",
        icon: "person.2",
        route: .myEmployees
    ),
    MyBusinessPage(
        title: "Cereri de angajare",
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
            .padding()
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
