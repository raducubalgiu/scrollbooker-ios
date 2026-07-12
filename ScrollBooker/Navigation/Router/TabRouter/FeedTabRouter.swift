//
//  FeedTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct FeedTabRouter: View {
    @EnvironmentObject private var container: AppContainer
    var router: Router
    
    var body: some View {
        @Bindable var bindableRouter = router
        
        NavigationStack(path: $bindableRouter.feedPath) {
            FeedScreen(onNavigateToFeedSearch: { router.push(.feedSearch) })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .toolbarBackground(Color.black, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
            .withNavigation { route in
                switch route {
                case .feedSearch:
                    FeedSearchScreen(
                        viewModel: container.searchModule.makeFeedSearchViewModel(),
                        onBack: { router.pop() }
                    )
                default:
                    nil
                }
            }
        }
        .toolbar(router.feedPath.isEmpty ? .visible : .hidden, for: .tabBar)
    }
}


