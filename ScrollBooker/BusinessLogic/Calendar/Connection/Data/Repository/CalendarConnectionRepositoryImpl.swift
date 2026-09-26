//
//  CalendarConnectionRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.09.2026.
//

final class CalendarConnectionRepositoryImpl: CalendarConnectionRepository {
    private let api: CalendarConnectionApiService
    private let provider = "google_calendar"

    init(api: CalendarConnectionApiService) {
        self.api = api
    }

    func getCalendarConnection() async throws -> CalendarConnection? {
        do {
            return try await api.getCalendarConnection(provider: provider).toDomain()
        } catch APIError.server(let status, _) where status == 404 {
            return nil
        }
    }

    func connectGoogleCalendar(serverAuthCode: String) async throws -> CalendarConnection {
        try await api.connectGoogleCalendar(
            request: ConnectGoogleCalendarRequest(serverAuthCode: serverAuthCode)
        ).toDomain()
    }

    func disconnectCalendarConnection() async throws {
        _ = try await api.disconnectCalendarConnection(provider: provider)
    }
}
