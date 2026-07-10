//
//  AppointmentCancelRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

struct AppointmentCancelRequest: Encodable {
    let canceled_reason: String
    let canceled_by_user_id: Int
}
