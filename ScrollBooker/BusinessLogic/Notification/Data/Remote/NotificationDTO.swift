//
//  NotificationDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation

struct NotificationDTO: Codable {
    let id: Int
    let type: String
    
    let sender_id: Int
    let receiver_id: Int
    
    let message: String?
    
    let is_read: Bool
    let is_deleted: Bool
    
    let sender: NotificationSenderDTO
}

struct NotificationSenderDTO: Codable {
    let id: Int
    let fullname: String
    let username: String
    let avatar: String?
}
