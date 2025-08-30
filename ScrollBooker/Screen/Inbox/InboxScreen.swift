//
//  InboxScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct InboxScreen: View {
    var onNavigateToEmployment: () -> Void
    
    var body: some View {
        Header(
            title: String(localized: "inbox"),
            enableBack: false
        )
        
        ScrollView {
            ForEach(dummyNotifications) { notification in
                NotificationItemView(
                    notification: notification,
                    onNavigateToEmployment: onNavigateToEmployment
                )
            }
        }
    }
}

#Preview("Light") {
    InboxScreen(
        onNavigateToEmployment: {}
    )
}

#Preview("Dark") {
    InboxScreen(
        onNavigateToEmployment: {}
    )
        .preferredColorScheme(.dark)
}
