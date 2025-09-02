//
//  SearchTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct SearchTabRouter: View {
    @ObservedObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.inboxPath) {
            BusinessProfileScreen()
//            SearchScreen(
//                onNavigateToBusinessProfile: { id in
//                    router.push(.businessProfile(id: id))
//                }
//            )
                .navigationDestination(for: Route.self) { route in
                    switch route {
//                    case .businessProfile(let id):
//                        BusinessProfileScreen(businessId: id)
//                            .navigationBarHidden(true)
//                            .toolbar(.hidden, for: .tabBar)
                    default: Text("Route not in Feed")
                    }
                }
        }
    }
}
