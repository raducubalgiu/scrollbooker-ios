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
                        onNavigateToBusinessProfile: { username in
                            router.push(.businessProfile(username: username))
                        }
                    )
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
        .toolbar(router.searchPath.isEmpty ? .visible : .hidden, for: .tabBar)
        .onAppear {
            if viewModel == nil {
                Task { @MainActor in
                    viewModel = container.businessModule.makeSearchViewModel(
                        getAllBusinessDomainsUseCase: container.businessDomainModule.getAllBusinessDomainsUseCase
                    )
                }
            }
        }
    }
}


