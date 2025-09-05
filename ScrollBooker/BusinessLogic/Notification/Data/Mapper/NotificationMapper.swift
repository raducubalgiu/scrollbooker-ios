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
        self.senderId = dto.sender_id
        self.receiverId = dto.receiver_id
        self.message = dto.message
        self.isRead = dto.is_read
        self.isDeleted = dto.is_deleted
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
