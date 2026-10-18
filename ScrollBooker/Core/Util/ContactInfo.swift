//
//  ContactInfo.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.10.2026.
//

import Foundation

/// Shared across `Post`/`UserProfile`/`BusinessProfile` — the backend resolves this once
/// (employee-vs-owner fallback, same shape as `instantBooking`) so every client just reads it.
struct ContactInfo: Codable, Equatable, Hashable, Sendable {
    let phone: String?
    let acceptsWhatsapp: Bool
    let acceptsCalls: Bool
}

struct ContactInfoDTO: Decodable {
    let phone: String?
    let acceptsWhatsapp: Bool
    let acceptsCalls: Bool

    enum CodingKeys: String, CodingKey {
        case phone
        case acceptsWhatsapp = "accepts_whatsapp"
        case acceptsCalls = "accepts_calls"
    }
}

extension ContactInfo {
    init(dto: ContactInfoDTO) {
        self.phone = dto.phone
        self.acceptsWhatsapp = dto.acceptsWhatsapp
        self.acceptsCalls = dto.acceptsCalls
    }
}
