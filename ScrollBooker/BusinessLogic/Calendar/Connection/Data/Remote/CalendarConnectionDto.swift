//
//  CalendarConnectionDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.09.2026.
//

struct CalendarConnectionDto: Decodable {
    let id: Int
    let provider: String
    let status: CalendarConnectionStatusEnum
    let googleAccountEmail: String?
    let lastSyncedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, provider, status
        case googleAccountEmail = "google_account_email"
        case lastSyncedAt = "last_synced_at"
    }
}

struct ConnectGoogleCalendarRequest: Encodable {
    let serverAuthCode: String

    enum CodingKeys: String, CodingKey {
        case serverAuthCode = "server_auth_code"
    }
}
