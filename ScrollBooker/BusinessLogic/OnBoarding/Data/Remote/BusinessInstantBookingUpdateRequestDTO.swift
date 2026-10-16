//
//  BusinessInstantBookingUpdateRequestDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.10.2026.
//

import Foundation

struct BusinessInstantBookingUpdateRequestDTO: Encodable {
    let instantBooking: Bool

    enum CodingKeys: String, CodingKey {
        case instantBooking = "instant_booking"
    }
}
