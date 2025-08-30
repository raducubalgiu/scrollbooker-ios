//
//  FeedTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct FeedTabRouter: View {
    @ObservedObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.feedPath) {
            FeedScreen(onNavigateToFeedSearch: { router.push(.feedSearch) })
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .feedSearch:
                        FeedSearchScreen()
                        .toolbar(.hidden, for: .tabBar)
                    default: Text("Route not in Feed")
                    }
                }
        }
    }
}
