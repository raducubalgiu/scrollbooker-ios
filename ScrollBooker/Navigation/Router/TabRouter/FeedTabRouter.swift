//
//  FeedTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct FeedTabRouter: View {
    @EnvironmentObject private var container: AppContainer
    @ObservedObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.feedPath) {
            FeedScreen(onNavigateToFeedSearch: { router.push(.feedSearch) })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .toolbarBackground(Color.black, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
            .withNavigation { route in
                switch route {
                case .feedSearch:
                    FeedSearchScreen(viewModel: container.searchModule.makeFeedSearchViewModel())
                        .toolbar(.hidden, for: .navigationBar)
                default:
                    nil
                }
            }
        }
        .toolbar(router.feedPath.isEmpty ? .visible : .hidden, for: .tabBar)
    }
}

