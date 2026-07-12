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
        NavigationStack(path: $router.searchPath) {
            SearchScreen(
                onNavigateToBusinessProfile: { id in
                    router.push(.businessProfile(id: id))
                }
            )
                .withGlobalNavigation()
        }
    }
}

