//
//  InboxScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct InboxScreen: View {
    let viewModel: InboxViewModel
    
    var onNavigateToAppointmentDetails: (Int) -> Void
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: String(localized: "notifications"),
                enableBack: false,
                onBack: {}
            )

            VStack {
                switch viewModel.viewState {
                    case .idle, .loading:
                        LoadingView()
                        
                    case .error(let message):
                        ErrorView(message: message) {
                            Task { await viewModel.refresh() }
                        }
                        
                    case .empty:
                        NoDataView(
                            title: String(localized: "notifications"),
                            message: String(localized: "notFoundNotifications"),
                            systemImage: "bell.badge"
                        )
                        
                    case .success(let notifications):
                        NotificationsListView(
                            notifications: notifications,
                            isPaging: viewModel.isPaging,
                            onRefresh: {
                                await viewModel.refresh()
                            },
                            onItemAppear: { notification in
                                Task {
                                    await viewModel.loadMoreIfNeeded(currentNotification: notification)
                                }
                            },
                            
                            onNavigateToAppointmentDetails: onNavigateToAppointmentDetails,
                            onNavigateToUserProfile: onNavigateToUserProfile
                        )
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            await viewModel.initialLoadIfNeeded()
        }
    }
}

//#Preview("Light") {
//    InboxScreen(
//        //onNavigateToEmployment: {}
//    )
//}
//
//#Preview("Dark") {
//    InboxScreen(
//        //onNavigateToEmployment: {}
//    )
//        .preferredColorScheme(.dark)
//}
