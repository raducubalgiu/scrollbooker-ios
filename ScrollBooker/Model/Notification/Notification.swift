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
    let data: [String: JSONValue]?
    let message: String?
    let isRead: Bool
    let isDeleted: Bool
    let sender: UserMini
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

enum JSONValue: Equatable, Hashable, Sendable {
    case string(String)
    case number(Double)
    case bool(Bool)
    case object([String: JSONValue])
    case array([JSONValue])
    case null
}
