//
//  NotificationsListView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import SwiftUI

struct NotificationsListView: View {
    let notifications: [Notification]
    let isPaging: Bool
    let onRefresh: () async -> Void
    let onItemAppear: (Notification) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(notifications) { notification in
                    NotificationItemView(
                        notification: notification,
                        onNavigateToUserProfile: { _ in },
                        onNavigateToEmploymentRequest: { _ in },
                        onNavigateToAppointmentDetails: { _ in }
                    )
                    .onAppear {
                        onItemAppear(notification)
                    }
                }
                
                if isPaging {
                    ProgressView()
                        .padding(.vertical)
                }
            }
        }
        .refreshable {
            await onRefresh()
        }
    }
}
