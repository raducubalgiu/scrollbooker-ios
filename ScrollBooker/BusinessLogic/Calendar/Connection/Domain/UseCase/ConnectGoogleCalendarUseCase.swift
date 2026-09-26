//
//  ConnectGoogleCalendarUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.09.2026.
//

final class ConnectGoogleCalendarUseCase {
    private let repository: CalendarConnectionRepository

    init(repository: CalendarConnectionRepository) {
        self.repository = repository
    }

    func callAsFunction(serverAuthCode: String) async throws -> CalendarConnection {
        try await repository.connectGoogleCalendar(serverAuthCode: serverAuthCode)
    }
}
