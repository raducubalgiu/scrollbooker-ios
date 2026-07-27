//
//  SearchTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct SearchTabRouter: View {
    var router: Router
    
    @EnvironmentObject private var container: AppContainer
    @State private var viewModel: SearchViewModel?
    
    var body: some View {
        @Bindable var bindableRouter = router
        
        NavigationStack(path: $bindableRouter.searchPath) {
            Group {
                if let stableViewModel = viewModel {
                    SearchScreen(
                        viewModel: stableViewModel,
                        onNavigateToBusinessProfile: { router.push(.businessProfile(username: $0)) },
                        onNavigateToBooking: { router.push(.bookingServices($0)) }
                    )
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        CustomTabBar(backgroundColor: .backgroundSB)
                    }
                } else {
                    ProgressView()
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .withNavigation { route in
                switch route {
                    case .businessProfile(let username):
                        BusinessProfileScreen(
                            viewModel: container.businessModule.makeBusinessProfileViewModel(username: username),
                            onBack: { router.pop() },
                            onNavigateToBusinessProfile: { username in
                                router.push(.businessProfile(username: username))
                            }
                        )
                        .toolbar(.hidden, for: .tabBar)
                    default:
                        nil
                    }
            }
        }
        .onChange(of: router.selectedTab, initial: true) { _, newTab in
            if newTab == .search && viewModel == nil {
                Task {
                    @MainActor in
                    viewModel = container.businessModule.makeSearchViewModel(
                        getAllBusinessDomainsUseCase: container.businessDomainModule.getAllBusinessDomainsUseCase
                    )
                }
            }
        }
    }
}


