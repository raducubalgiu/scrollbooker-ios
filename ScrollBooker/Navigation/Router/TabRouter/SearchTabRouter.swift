//
//  SearchTabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct SearchTabRouter: View {
    var router: Router
    
    var body: some View {
        @Bindable var bindableRouter = router
        
        NavigationStack(path: $bindableRouter.searchPath) {
            SearchScreen(
//                onNavigateToBusinessProfile: { id in
//                    router.push(.businessProfile(id: id))
//                }
            )
            .toolbar(.hidden, for: .navigationBar)
            .withNavigation { route in
                switch route {
                    case .businessProfile(_):
                        BusinessProfileScreen()
                            .toolbar(.hidden, for: .tabBar)
                    default:
                        nil
                    }
            }
        }
        .toolbar(router.searchPath.isEmpty ? .visible : .hidden, for: .tabBar)
    }
}


