//
//  Notification.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import Foundation

struct Notification: Identifiable, Equatable, Hashable {
    let id: Int
    let type: NotificationType
    let senderId: Int
    let receiverId: Int
    let message: String?
    let isRead: Bool
    let isDeleted: Bool
    let sender: NotificationSender
}

struct NotificationSender: Codable, Equatable, Hashable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
}

enum NotificationType: String, Equatable, Hashable, Sendable {
    case follow
    case like
    case employmentRequest = "employment_request"
    case unknown
}

extension NotificationType {
    init(from rawValue: String) {
        self = NotificationType(rawValue: rawValue) ?? .unknown
    }
    
    var message: String {
        switch self {
        case .follow:
            return String(localized: "startedFollowingYou")
        case .like:
            return String(localized: "likedYourPost")
        case .employmentRequest:
            return String(localized: "sentYouAnEmploymentRequest")
        case .unknown:
            return ""
        }
    }
}
