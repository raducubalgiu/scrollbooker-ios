//
//  NotificationItemView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct NotificationItemView: View {
    var notification: Notification

    var onNavigateToUserProfile: (String) -> Void
    var onNavigateToEmploymentRequest: (Int) -> Void
    var onNavigateToAppointmentDetails: (Int) -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            avatarWithBadge

            VStack(alignment: .leading, spacing: 2) {
                if !notification.sender.fullName.isEmpty {
                    Text(notification.sender.fullName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.onBackgroundSB)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }

                Text(notification.data.contentText)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 8)

            trailingContent
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(notification.isRead ? Color.clear : Color.onBackgroundSB.opacity(0.05))
        .contentShape(Rectangle())
        .onTapGesture {
            handleTap()
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }

    @ViewBuilder
    private var avatarWithBadge: some View {
        ZStack(alignment: .bottomTrailing) {
            AvatarView(
                imageURL: URL(string: notification.sender.avatar ?? ""),
                size: .l
            )

            if let badge = notification.type.badgeConfig {
                Circle()
                    .fill(badge.color)
                    .frame(width: 18, height: 18)
                    .overlay(
                        Image(systemName: badge.icon)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white)
                    )
                    .overlay(
                        Circle().stroke(Color(.systemBackground), lineWidth: 2)
                    )
            }
        }
    }

    @ViewBuilder
    private var trailingContent: some View {
        if let imageURL = contentImageURL {
            AsyncImage(url: imageURL) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color(.systemGray5)
            }
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        } else {
            actionButton
        }
    }

    private var contentImageURL: URL? {
        switch notification.data {
        case .likePost(let d):
            return d.postUrl.flatMap(URL.init)
        case .commentPost(let d):
            return d.postUrl.flatMap(URL.init)
        case .repost(let d):
            return d.postUrl.flatMap(URL.init)
        default:
            return nil
        }
    }

    @ViewBuilder
    private var actionButton: some View {
        switch notification.data {
        case .follow:
            MainButtonMini(
                title: String(localized: "follow"),
                style: .outlined,
                onClick: {}
            )

        case .appointmentBooked(let d):
            MainButtonMini(
                title: String(localized: "details"),
                backgroundColor: .primarySB,
                onClick: { onNavigateToAppointmentDetails(d.appointmentId) }
            )

        case .appointmentCanceled(let d):
            MainButtonMini(
                title: String(localized: "details"),
                backgroundColor: .primarySB,
                onClick: { onNavigateToAppointmentDetails(d.appointmentId) }
            )

        case .appointmentRescheduled(let d):
            MainButtonMini(
                title: String(localized: "check"),
                backgroundColor: .primarySB,
                onClick: { onNavigateToAppointmentDetails(d.appointmentId) }
            )

        case .appointmentReviewed(let d):
            MainButtonMini(
                title: String(localized: "details"),
                backgroundColor: .primarySB,
                onClick: { onNavigateToAppointmentDetails(d.appointmentId) }
            )

        case .employmentRequest(let d):
            MainButtonMini(
                title: String(localized: "seeMore"),
                backgroundColor: .errorSB,
                onClick: { onNavigateToEmploymentRequest(d.employmentRequestId) }
            )

        default:
            EmptyView()
        }
    }

    private func handleTap() {
        switch notification.data {
        case .appointmentReviewed(let d):
            onNavigateToAppointmentDetails(d.appointmentId)

        case .appointmentBooked(let d):
            onNavigateToAppointmentDetails(d.appointmentId)
        case .appointmentCanceled(let d):
            onNavigateToAppointmentDetails(d.appointmentId)
        case .appointmentRescheduled(let d):
            onNavigateToAppointmentDetails(d.appointmentId)
        case .appointmentReminder(let d):
            onNavigateToAppointmentDetails(d.appointmentId)

        case .likePost, .commentPost, .repost, .mentionPost:
            break

        default:
            if !notification.sender.username.isEmpty {
                onNavigateToUserProfile(notification.sender.username)
            }
        }
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
