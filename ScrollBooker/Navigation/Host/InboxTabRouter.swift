//
//  InboxTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct InboxTabRouter: View {
    @ObservedObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.inboxPath) {
            InboxScreen()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    default: Text("Route not in Feed")
                    }
                }
        }
    }
}

//#Preview {
//    InboxTabRouter()
//}
