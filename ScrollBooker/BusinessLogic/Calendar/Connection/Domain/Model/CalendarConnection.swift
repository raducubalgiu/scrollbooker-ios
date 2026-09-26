//
//  CalendarConnection.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.09.2026.
//

struct CalendarConnection: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let provider: String
    let status: CalendarConnectionStatusEnum
    let googleAccountEmail: String?
    let lastSyncedAt: String?

    var isActive: Bool { status == .active }
}
