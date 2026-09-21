//
//  AppointmentBlockRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

struct AppointmentBlockRequestDTO: Encodable {
    let blockedMessage: String?
    let slots: [AppointmentBlockSlotDTO]

    enum CodingKeys: String, CodingKey {
        case blockedMessage = "blocked_message"
        case slots
    }
}

struct AppointmentBlockSlotDTO: Encodable {
    let startDate: String
    let endDate: String
    let userId: Int

    enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
        case userId = "user_id"
    }
}
