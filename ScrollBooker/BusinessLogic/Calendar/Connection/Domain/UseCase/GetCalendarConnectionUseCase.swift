//
//  GetCalendarConnectionUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.09.2026.
//

final class GetCalendarConnectionUseCase {
    private let repository: CalendarConnectionRepository

    init(repository: CalendarConnectionRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws -> CalendarConnection? {
        try await repository.getCalendarConnection()
    }
}
