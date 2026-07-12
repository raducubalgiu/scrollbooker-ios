//
//  Notification.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import Foundation
import SwiftUI

enum NotificationType: String, Equatable, Hashable, Sendable {
    case follow
    case likePost = "like_post"
    case commentPost = "comment_post"
    case repost
    case mentionPost = "mention_post"
    case appointmentBooked = "appointment_booked"
    case appointmentCanceled = "appointment_canceled"
    case appointmentRescheduled = "appointment_rescheduled"
    case appointmentReminder = "appointment_reminder"
    case appointmentReviewed = "appointment_reviewed"
    case employmentRequest = "employment_request"
    case employmentRequestAccepted = "employment_request_accepted"
    case employmentRequestDenied = "employment_request_denied"
    case businessValidation = "business_validation"
    case unknown
}

struct FollowNotificationData: Equatable, Hashable {}

struct LikePostNotificationData: Equatable, Hashable {
    let postId: Int
    let actorIds: [Int]
    let postUrl: String?
    let totalCount: Int
}

struct CommentPostNotificationData: Equatable, Hashable {
    let postId: Int
    let actorIds: [Int]
    let postUrl: String?
    let totalCount: Int
}

struct RepostNotificationData: Equatable, Hashable {
    let postId: Int
    let actorIds: [Int]
    let postUrl: String?
    let totalCount: Int
}

struct MentionPostNotificationData: Equatable, Hashable {
    let postId: Int
    let commentId: Int?
}

struct AppointmentBookedNotificationData: Equatable, Hashable {
    let appointmentId: Int
    let customerId: Int
    let startDate: String
    let customerFullname: String
}

struct AppointmentCanceledNotificationData: Equatable, Hashable {
    let appointmentId: Int
    let canceledByUserId: Int
    let canceledReason: String?
}

struct AppointmentRescheduledNotificationData: Equatable, Hashable {
    let appointmentId: Int
    let oldStartDate: String
    let newStartDate: String
}

struct AppointmentReminderNotificationData: Equatable, Hashable {
    let appointmentId: Int
    let startDate: String
}

struct AppointmentReviewedNotificationData: Equatable, Hashable {
    let appointmentId: Int
    let reviewId: Int
    let rating: Int
}

struct EmploymentRequestNotificationData: Equatable, Hashable {
    let employmentRequestId: Int
    let professionId: Int
    let professionName: String
    let businessId: Int
}

struct EmploymentRequestAcceptedNotificationData: Equatable, Hashable {
    let employmentRequestId: Int
    let businessId: Int
}

struct EmploymentRequestDeniedNotificationData: Equatable, Hashable {
    let employmentRequestId: Int
    let businessId: Int
}

struct BusinessValidationNotificationData: Equatable, Hashable {
    let businessId: Int
    let isApproved: Bool
    let reason: String?
}

enum NotificationData: Equatable, Hashable {
    case follow(FollowNotificationData)
    case likePost(LikePostNotificationData)
    case commentPost(CommentPostNotificationData)
    case repost(RepostNotificationData)
    case mentionPost(MentionPostNotificationData)
    case appointmentBooked(AppointmentBookedNotificationData)
    case appointmentCanceled(AppointmentCanceledNotificationData)
    case appointmentRescheduled(AppointmentRescheduledNotificationData)
    case appointmentReminder(AppointmentReminderNotificationData)
    case appointmentReviewed(AppointmentReviewedNotificationData)
    case employmentRequest(EmploymentRequestNotificationData)
    case employmentRequestAccepted(EmploymentRequestAcceptedNotificationData)
    case employmentRequestDenied(EmploymentRequestDeniedNotificationData)
    case businessValidation(BusinessValidationNotificationData)
    case unknown
}

struct NotificationSender: Equatable, Hashable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
}

struct Notification: Identifiable, Equatable, Hashable {
    let id: Int
    let type: NotificationType
    let senderId: Int
    let receiverId: Int
    let data: NotificationData
    let isRead: Bool
    let isDeleted: Bool
    let sender: NotificationSender
}

// Extensions

extension NotificationType {
    init(from rawValue: String) {
        self = NotificationType(rawValue: rawValue) ?? .unknown
    }
    
    var badgeConfig: (icon: String, color: Color)? {
        switch self {
            case .likePost:
                return ("heart.fill", .red)
            case .commentPost:
                return ("bubble.left.fill", Color(red: 0, green: 0.69, blue: 1))
            case .repost:
                return ("arrow.2.squarepath", Color(red: 0, green: 0.9, blue: 0.46))
            case .mentionPost:
                return ("at", Color(red: 0.61, green: 0.15, blue: 0.69))
            case .appointmentBooked, .appointmentRescheduled, .appointmentReminder:
                return ("calendar", Color(red: 0.16, green: 0.47, blue: 1))
            case .appointmentCanceled:
                return ("calendar", .red)
            case .appointmentReviewed:
                return nil
            case .employmentRequest, .employmentRequestAccepted:
                return ("briefcase.fill", Color(red: 1, green: 0.57, blue: 0))
            case .employmentRequestDenied:
                return ("briefcase.fill", .red)
            case .businessValidation:
                return ("checkmark.seal.fill", Color(red: 0.3, green: 0.69, blue: 0.31))
            case .follow, .unknown:
                return nil
        }
    }
}

extension NotificationData {
    var likePost: LikePostNotificationData? {
        if case .likePost(let d) = self { return d }
        return nil
    }
    var employmentRequest: EmploymentRequestNotificationData? {
        if case .employmentRequest(let d) = self { return d }
        return nil
    }
    
    var contentText: String {
        switch self {
            case .follow:
                return String(localized: "notification_follow")

            case .likePost(let d):
                if d.totalCount > 1 {
                    return String(
                        localized: LocalizedStringResource("notification_like_post_and_others",
                        defaultValue: "ți-a apreciat postarea ta și încă \(d.totalCount - 1) persoane")
                    )
                }
                return String(localized: "notification_like_post")

            case .commentPost:
                return String(localized: "notification_comment")

            case .repost:
                return String(localized: "notification_repost")

            case .mentionPost:
                return String(localized: "notification_mention_post")

            case .appointmentBooked(let d):
                let dateText = d.startDate.asISO8601Date()?.asFormattedString() ?? d.startDate
                return String(
                    localized: LocalizedStringResource("notification_appointment_booked",
                    defaultValue: "a efectuat o programare pentru data de \(dateText)")
                )

            case .appointmentCanceled(let d):
                if let reason = d.canceledReason, !reason.isEmpty {
                    return String(
                        localized: LocalizedStringResource("notification_appointment_canceled_with_reason",
                        defaultValue: "a anulat programarea. Motiv: \(reason)")
                    )
                }
                return String(localized: "notification_appointment_canceled")

            case .appointmentRescheduled(let d):
                let dateText = d.newStartDate.asISO8601Date()?.asFormattedString() ?? d.newStartDate
                return String(
                    localized: LocalizedStringResource("notification_appointment_rescheduled",
                    defaultValue: "Programarea a fost replanificată pe \(dateText)")
                )

            case .appointmentReminder:
                return String(localized: "notification_appointment_reminder")

            case .appointmentReviewed(let d):
                return String(
                    localized: LocalizedStringResource("notification_appointment_reviewed",
                    defaultValue: "A lăsat o recenzie de \(d.rating) stele pentru programarea finalizată.")
                )

            case .employmentRequest(let d):
                return String(
                    localized: LocalizedStringResource("notification_employment_request",
                    defaultValue: "Ai primit o cerere de angajare pentru rolul de \(d.professionName)")
                )

            case .employmentRequestAccepted:
                return String(localized: "notification_employment_accepted")

            case .employmentRequestDenied:
                return String(localized: "notification_employment_denied")

            case .businessValidation(let d):
                if d.isApproved {
                    return String(localized: "notification_business_validation_approved")
                }
                let reason = d.reason ?? String(localized: "unspecified")
                return String(
                    localized: LocalizedStringResource("notification_business_validation_rejected",
                    defaultValue: "Afacerea ta a fost respinsă. Motiv: \(reason)")
                )

            case .unknown:
                return String(localized: "notification_received_new")
            }
        }
}
