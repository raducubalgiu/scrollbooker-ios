//
//  CalendarConnectionApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.09.2026.
//

import Foundation

protocol CalendarConnectionApiService: Sendable {
    func getCalendarConnection(provider: String) async throws -> CalendarConnectionDto
    func connectGoogleCalendar(request: ConnectGoogleCalendarRequest) async throws -> CalendarConnectionDto
    func disconnectCalendarConnection(provider: String) async throws -> NoContent
}

final class CalendarConnectionAPIImpl: CalendarConnectionApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func getCalendarConnection(provider: String) async throws -> CalendarConnectionDto {
        try await client.request(
            "integrations/calendar/connections/me",
            method: .get,
            query: ["provider": provider]
        )
    }

    func connectGoogleCalendar(request: ConnectGoogleCalendarRequest) async throws -> CalendarConnectionDto {
        try await client.request(
            "integrations/calendar/connections/google",
            method: .post,
            body: request
        )
    }

    func disconnectCalendarConnection(provider: String) async throws -> NoContent {
        try await client.request(
            "integrations/calendar/connections/me",
            method: .delete,
            query: ["provider": provider]
        )
    }
}
