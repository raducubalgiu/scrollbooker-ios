//
//  CalendarConnectionMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.09.2026.
//

extension CalendarConnectionDto {
    func toDomain() -> CalendarConnection {
        CalendarConnection(
            id: id,
            provider: provider,
            status: status,
            googleAccountEmail: googleAccountEmail,
            lastSyncedAt: lastSyncedAt
        )
    }
}
