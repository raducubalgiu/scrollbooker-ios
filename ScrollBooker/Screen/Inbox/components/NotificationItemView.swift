//
//  NotificationItemView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct NotificationItemView: View {
    var notification: Notification
    var onNavigateToEmployment: () -> Void
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                AvatarView(
                    imageURL: URL(string: "https://media.scrollbooker.ro/avatar-male-9.jpeg"),
                    size: .l
                )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(notification.sender.fullName)
                        .font(.headline)
                        .foregroundColor(.onBackgroundSB)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text(notification.type.message)
                        .font(.subheadline)
                        .foregroundColor(.onBackgroundSB)
                }
                
                Spacer()
                
                MainButtonMini(
                    title: notification.type.rawValue != "employment_request" ? "Urmareste" : String(localized: "seeMore"),
                    backgroundColor: notification.type.rawValue != "employment_request" ? .primarySB : .errorSB,
                    onClick: onNavigateToEmployment
                )
            }
        }
        .contentShape(Rectangle())
        .padding(.vertical, 10)
    }
}

//#Preview("Light") {
//    NotificationItemView(
//        notification: dummyNotifications[0],
//        onNavigateToEmployment: {}
//    )
//}
//
//#Preview("Dark") {
//    NotificationItemView(
//        notification: dummyNotifications[0],
//        onNavigateToEmployment: {}
//    )
//}
