//
//  NotificationMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation

extension Notification {
    init(dto: NotificationDTO) {
        self.id = dto.id
        self.type = NotificationType(from: dto.type)
        self.senderId = dto.senderId
        self.receiverId = dto.receiverId
        self.data = NotificationData(dto: dto.data)
        self.isRead = dto.isRead
        self.isDeleted = dto.isDeleted
        self.sender = NotificationSender(dto: dto.sender)
    }
}

extension NotificationSender {
    init(dto: NotificationSenderDTO) {
        self.id = dto.id
        self.fullName = dto.fullname
        self.username = dto.username
        self.avatar = dto.avatar
    }
}

extension NotificationData {
    init(dto: NotificationDataDTO) {
        switch dto {
        case .follow:
            self = .follow(FollowNotificationData())
        case .likePost(let d):
            self = .likePost(LikePostNotificationData(dto: d))
        case .commentPost(let d):
            self = .commentPost(CommentPostNotificationData(dto: d))
        case .repost(let d):
            self = .repost(RepostNotificationData(dto: d))
        case .mentionPost(let d):
            self = .mentionPost(MentionPostNotificationData(dto: d))
        case .appointmentBooked(let d):
            self = .appointmentBooked(AppointmentBookedNotificationData(dto: d))
        case .appointmentCanceled(let d):
            self = .appointmentCanceled(AppointmentCanceledNotificationData(dto: d))
        case .appointmentRescheduled(let d):
            self = .appointmentRescheduled(AppointmentRescheduledNotificationData(dto: d))
        case .appointmentReminder(let d):
            self = .appointmentReminder(AppointmentReminderNotificationData(dto: d))
        case .appointmentReviewed(let d):
            self = .appointmentReviewed(AppointmentReviewedNotificationData(dto: d))
        case .employmentRequest(let d):
            self = .employmentRequest(EmploymentRequestNotificationData(dto: d))
        case .employmentRequestAccepted(let d):
            self = .employmentRequestAccepted(EmploymentRequestAcceptedNotificationData(dto: d))
        case .employmentRequestDenied(let d):
            self = .employmentRequestDenied(EmploymentRequestDeniedNotificationData(dto: d))
        case .businessValidation(let d):
            self = .businessValidation(BusinessValidationNotificationData(dto: d))
        case .unknown:
            self = .unknown
        }
    }
}

extension LikePostNotificationData {
    init(dto: LikePostNotificationDataDTO) {
        self.postId = dto.postId
        self.actorIds = dto.actorIds
        self.postUrl = dto.postUrl
        self.totalCount = dto.totalCount
    }
}

extension CommentPostNotificationData {
    init(dto: CommentPostNotificationDataDTO) {
        self.postId = dto.postId
        self.actorIds = dto.actorIds
        self.postUrl = dto.postUrl
        self.totalCount = dto.totalCount
    }
}

extension RepostNotificationData {
    init(dto: RepostNotificationDataDTO) {
        self.postId = dto.postId
        self.actorIds = dto.actorIds
        self.postUrl = dto.postUrl
        self.totalCount = dto.totalCount
    }
}

extension MentionPostNotificationData {
    init(dto: MentionPostNotificationDataDTO) {
        self.postId = dto.postId
        self.commentId = dto.commentId
    }
}

extension AppointmentBookedNotificationData {
    init(dto: AppointmentBookedNotificationDataDTO) {
        self.appointmentId = dto.appointmentId
        self.customerId = dto.customerId
        self.startDate = dto.startDate
        self.customerFullname = dto.customerFullname
    }
}

extension AppointmentCanceledNotificationData {
    init(dto: AppointmentCanceledNotificationDataDTO) {
        self.appointmentId = dto.appointmentId
        self.canceledByUserId = dto.canceledByUserId
        self.canceledReason = dto.canceledReason
    }
}

extension AppointmentRescheduledNotificationData {
    init(dto: AppointmentRescheduledNotificationDataDTO) {
        self.appointmentId = dto.appointmentId
        self.oldStartDate = dto.oldStartDate
        self.newStartDate = dto.newStartDate
    }
}

extension AppointmentReminderNotificationData {
    init(dto: AppointmentReminderNotificationDataDTO) {
        self.appointmentId = dto.appointmentId
        self.startDate = dto.startDate
    }
}

extension AppointmentReviewedNotificationData {
    init(dto: AppointmentReviewedNotificationDataDTO) {
        self.appointmentId = dto.appointmentId
        self.reviewId = dto.reviewId
        self.rating = dto.rating
    }
}

extension EmploymentRequestNotificationData {
    init(dto: EmploymentRequestNotificationDataDTO) {
        self.employmentRequestId = dto.employmentRequestId
        self.professionId = dto.professionId
        self.professionName = dto.professionName
        self.businessId = dto.businessId
    }
}

extension EmploymentRequestAcceptedNotificationData {
    init(dto: EmploymentRequestAcceptedNotificationDataDTO) {
        self.employmentRequestId = dto.employmentRequestId
        self.businessId = dto.businessId
    }
}

extension EmploymentRequestDeniedNotificationData {
    init(dto: EmploymentRequestDeniedNotificationDataDTO) {
        self.employmentRequestId = dto.employmentRequestId
        self.businessId = dto.businessId
    }
}

extension BusinessValidationNotificationData {
    init(dto: BusinessValidationNotificationDataDTO) {
        self.businessId = dto.businessId
        self.isApproved = dto.isApproved
        self.reason = dto.reason
    }
}
