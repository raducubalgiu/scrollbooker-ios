//
//  NotificationDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation

struct FollowNotificationDataDTO: Decodable {}

struct LikePostNotificationDataDTO: Decodable {
    let postId: Int
    let actorIds: [Int]
    let postUrl: String?
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case actorIds = "actor_ids"
        case postUrl = "post_url"
        case totalCount = "total_count"
    }
}

struct CommentPostNotificationDataDTO: Decodable {
    let postId: Int
    let actorIds: [Int]
    let postUrl: String?
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case actorIds = "actor_ids"
        case postUrl = "post_url"
        case totalCount = "total_count"
    }
}

struct RepostNotificationDataDTO: Decodable {
    let postId: Int
    let actorIds: [Int]
    let postUrl: String?
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case actorIds = "actor_ids"
        case postUrl = "post_url"
        case totalCount = "total_count"
    }
}

struct MentionPostNotificationDataDTO: Decodable {
    let postId: Int
    let commentId: Int?

    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case commentId = "comment_id"
    }
}

struct AppointmentBookedNotificationDataDTO: Decodable {
    let appointmentId: Int
    let customerId: Int
    let startDate: String
    let customerFullname: String

    enum CodingKeys: String, CodingKey {
        case appointmentId = "appointment_id"
        case customerId = "customer_id"
        case startDate = "start_date"
        case customerFullname = "customer_fullname"
    }
}

struct AppointmentCanceledNotificationDataDTO: Decodable {
    let appointmentId: Int
    let canceledByUserId: Int
    let canceledReason: String?

    enum CodingKeys: String, CodingKey {
        case appointmentId = "appointment_id"
        case canceledByUserId = "canceled_by_user_id"
        case canceledReason = "canceled_reason"
    }
}

struct AppointmentRescheduledNotificationDataDTO: Decodable {
    let appointmentId: Int
    let oldStartDate: String
    let newStartDate: String

    enum CodingKeys: String, CodingKey {
        case appointmentId = "appointment_id"
        case oldStartDate = "old_start_date"
        case newStartDate = "new_start_date"
    }
}

struct AppointmentReminderNotificationDataDTO: Decodable {
    let appointmentId: Int
    let startDate: String

    enum CodingKeys: String, CodingKey {
        case appointmentId = "appointment_id"
        case startDate = "start_date"
    }
}

struct AppointmentReviewedNotificationDataDTO: Decodable {
    let appointmentId: Int
    let reviewId: Int
    let rating: Int

    enum CodingKeys: String, CodingKey {
        case appointmentId = "appointment_id"
        case reviewId = "review_id"
        case rating
    }
}

struct EmploymentRequestNotificationDataDTO: Decodable {
    let employmentRequestId: Int
    let professionId: Int
    let professionName: String
    let businessId: Int

    enum CodingKeys: String, CodingKey {
        case employmentRequestId = "employment_request_id"
        case professionId = "profession_id"
        case professionName = "profession_name"
        case businessId = "business_id"
    }
}

struct EmploymentRequestAcceptedNotificationDataDTO: Decodable {
    let employmentRequestId: Int
    let businessId: Int

    enum CodingKeys: String, CodingKey {
        case employmentRequestId = "employment_request_id"
        case businessId = "business_id"
    }
}

struct EmploymentRequestDeniedNotificationDataDTO: Decodable {
    let employmentRequestId: Int
    let businessId: Int

    enum CodingKeys: String, CodingKey {
        case employmentRequestId = "employment_request_id"
        case businessId = "business_id"
    }
}

struct BusinessValidationNotificationDataDTO: Decodable {
    let businessId: Int
    let isApproved: Bool
    let reason: String?

    enum CodingKeys: String, CodingKey {
        case businessId = "business_id"
        case isApproved = "is_approved"
        case reason
    }
}

// MARK: - Discriminated union DTO (based on `type`)

enum NotificationDataDTO: Decodable {
    case follow(FollowNotificationDataDTO)
    case likePost(LikePostNotificationDataDTO)
    case commentPost(CommentPostNotificationDataDTO)
    case repost(RepostNotificationDataDTO)
    case mentionPost(MentionPostNotificationDataDTO)
    case appointmentBooked(AppointmentBookedNotificationDataDTO)
    case appointmentCanceled(AppointmentCanceledNotificationDataDTO)
    case appointmentRescheduled(AppointmentRescheduledNotificationDataDTO)
    case appointmentReminder(AppointmentReminderNotificationDataDTO)
    case appointmentReviewed(AppointmentReviewedNotificationDataDTO)
    case employmentRequest(EmploymentRequestNotificationDataDTO)
    case employmentRequestAccepted(EmploymentRequestAcceptedNotificationDataDTO)
    case employmentRequestDenied(EmploymentRequestDeniedNotificationDataDTO)
    case businessValidation(BusinessValidationNotificationDataDTO)
    case unknown

    // Not called directly by JSONDecoder - built manually from NotificationDTO's init(from:)
    init(from decoder: Decoder) throws {
        self = .unknown
    }

    init(type: NotificationType, decoder: Decoder) throws {
        switch type {
        case .follow:
            self = .follow(try FollowNotificationDataDTO(from: decoder))
        case .likePost:
            self = .likePost(try LikePostNotificationDataDTO(from: decoder))
        case .commentPost:
            self = .commentPost(try CommentPostNotificationDataDTO(from: decoder))
        case .repost:
            self = .repost(try RepostNotificationDataDTO(from: decoder))
        case .mentionPost:
            self = .mentionPost(try MentionPostNotificationDataDTO(from: decoder))
        case .appointmentBooked:
            self = .appointmentBooked(try AppointmentBookedNotificationDataDTO(from: decoder))
        case .appointmentCanceled:
            self = .appointmentCanceled(try AppointmentCanceledNotificationDataDTO(from: decoder))
        case .appointmentRescheduled:
            self = .appointmentRescheduled(try AppointmentRescheduledNotificationDataDTO(from: decoder))
        case .appointmentReminder:
            self = .appointmentReminder(try AppointmentReminderNotificationDataDTO(from: decoder))
        case .appointmentReviewed:
            self = .appointmentReviewed(try AppointmentReviewedNotificationDataDTO(from: decoder))
        case .employmentRequest:
            self = .employmentRequest(try EmploymentRequestNotificationDataDTO(from: decoder))
        case .employmentRequestAccepted:
            self = .employmentRequestAccepted(try EmploymentRequestAcceptedNotificationDataDTO(from: decoder))
        case .employmentRequestDenied:
            self = .employmentRequestDenied(try EmploymentRequestDeniedNotificationDataDTO(from: decoder))
        case .businessValidation:
            self = .businessValidation(try BusinessValidationNotificationDataDTO(from: decoder))
        case .unknown:
            self = .unknown
        }
    }
}

// MARK: - Root DTOs

struct NotificationSenderDTO: Decodable {
    let id: Int
    let fullname: String
    let username: String
    let avatar: String?
}

struct NotificationDTO: Decodable {
    let id: Int
    let type: String
    let senderId: Int
    let receiverId: Int
    let data: NotificationDataDTO
    let isRead: Bool
    let isDeleted: Bool
    let sender: NotificationSenderDTO

    enum CodingKeys: String, CodingKey {
        case id, type
        case senderId = "sender_id"
        case receiverId = "receiver_id"
        case data
        case isRead = "is_read"
        case isDeleted = "is_deleted"
        case sender
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        senderId = try container.decode(Int.self, forKey: .senderId)
        receiverId = try container.decode(Int.self, forKey: .receiverId)
        isRead = try container.decode(Bool.self, forKey: .isRead)
        isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        sender = try container.decode(NotificationSenderDTO.self, forKey: .sender)

        let notifType = NotificationType(from: type)
        let dataDecoder = try container.superDecoder(forKey: .data)
        data = try NotificationDataDTO(type: notifType, decoder: dataDecoder)
    }
}
