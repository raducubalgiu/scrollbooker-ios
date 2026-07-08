//
//  Notification.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import Foundation

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

extension NotificationType {
    init(from rawValue: String) {
        self = NotificationType(rawValue: rawValue) ?? .unknown
    }
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

extension NotificationData {
    var likePost: LikePostNotificationData? {
        if case .likePost(let d) = self { return d }
        return nil
    }
    var employmentRequest: EmploymentRequestNotificationData? {
        if case .employmentRequest(let d) = self { return d }
        return nil
    }
    // adaugă restul dacă ai nevoie de ele des în UI
}

// MARK: - Root models

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
