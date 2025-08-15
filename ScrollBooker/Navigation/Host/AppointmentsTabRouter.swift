//
//  AppointmentsTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct AppointmentsTabRouter: View {
    @ObservedObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.appointmentsPath) {
            AppointmentsScreen()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    default: Text("Route not in Appointments")
                    }
                }
        }
    }
}

//#Preview {
//    AppointmentsRouter()
//}
