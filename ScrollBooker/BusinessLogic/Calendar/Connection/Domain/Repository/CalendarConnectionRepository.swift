//
//  CalendarConnectionRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.09.2026.
//

protocol CalendarConnectionRepository: Sendable {
    func getCalendarConnection() async throws -> CalendarConnection?
    func connectGoogleCalendar(serverAuthCode: String) async throws -> CalendarConnection
    func disconnectCalendarConnection() async throws
}
