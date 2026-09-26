//
//  CalendarConnectionViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class CalendarConnectionViewModel {
    private(set) var connectionState: FeatureState<CalendarConnection?> = .idle
    private(set) var isProcessing = false

    private let getCalendarConnectionUseCase: GetCalendarConnectionUseCase
    private let connectGoogleCalendarUseCase: ConnectGoogleCalendarUseCase
    private let disconnectCalendarConnectionUseCase: DisconnectCalendarConnectionUseCase
    private let googleCalendarAuthorizationProvider: GoogleCalendarAuthorizationProvider
    private let toastCenter: ToastCenter
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "CalendarConnection")

    init(
        getCalendarConnectionUseCase: GetCalendarConnectionUseCase,
        connectGoogleCalendarUseCase: ConnectGoogleCalendarUseCase,
        disconnectCalendarConnectionUseCase: DisconnectCalendarConnectionUseCase,
        googleCalendarAuthorizationProvider: GoogleCalendarAuthorizationProvider,
        toastCenter: ToastCenter
    ) {
        self.getCalendarConnectionUseCase = getCalendarConnectionUseCase
        self.connectGoogleCalendarUseCase = connectGoogleCalendarUseCase
        self.disconnectCalendarConnectionUseCase = disconnectCalendarConnectionUseCase
        self.googleCalendarAuthorizationProvider = googleCalendarAuthorizationProvider
        self.toastCenter = toastCenter
    }

    var connection: CalendarConnection? {
        connectionState.data.flatMap { $0 }
    }

    var statusLabel: String {
        switch connectionState {
            case .idle, .loading: ""
            case .error: String(localized: "calendarNotConnected")
            case .success(let connection):
                (connection?.isActive == true) ? String(localized: "calendarConnected") : String(localized: "calendarNotConnected")
        }
    }

    func loadConnection() async {
        guard connectionState == .idle else { return }
        connectionState = .loading

        do {
            let connection = try await getCalendarConnectionUseCase()
            connectionState = .success(connection)
        } catch {
            logger.error("ERROR: on fetching calendar connection: \(error.localizedDescription, privacy: .public)")
            connectionState = .error(logger.userMessage(for: error, context: "Loading Calendar Connection"))
        }
    }

    func connect() async {
        guard !isProcessing else { return }
        isProcessing = true

        do {
            let serverAuthCode = try await googleCalendarAuthorizationProvider.requestServerAuthCode()
            let connection = try await connectGoogleCalendarUseCase(serverAuthCode: serverAuthCode)
            connectionState = .success(connection)
        } catch {
            logger.error("ERROR: on connecting Google Calendar: \(error.localizedDescription, privacy: .public)")
            toastCenter.show(logger.userMessage(for: error, context: "Connecting Google Calendar"), type: .error)
        }

        isProcessing = false
    }

    func disconnect() async {
        guard !isProcessing, connection != nil else { return }
        isProcessing = true

        do {
            try await disconnectCalendarConnectionUseCase()
            connectionState = .success(nil)
        } catch {
            logger.error("ERROR: on disconnecting Google Calendar: \(error.localizedDescription, privacy: .public)")
            toastCenter.show(logger.userMessage(for: error, context: "Disconnecting Google Calendar"), type: .error)
        }

        isProcessing = false
    }
}
