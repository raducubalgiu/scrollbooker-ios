//
//  CalendarConnectionSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.09.2026.
//

import SwiftUI

struct CalendarConnectionSheetView: View {
    @Environment(\.dismiss) private var dismiss
    var viewModel: CalendarConnectionViewModel

    @State private var showDisconnectConfirm = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SheetHeaderView(onDismiss: { dismiss() }, title: String(localized: "calendarConnection"))

            VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                Text(String(localized: "calendarConnectionDescription"))
                    .font(.footnote)
                    .foregroundColor(.gray)

                content

                actionButton
            }
            .padding(.base)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .task {
            await viewModel.loadConnection()
        }
        .confirmationDialog(
            String(localized: "disconnectGoogleCalendar"),
            isPresented: $showDisconnectConfirm,
            titleVisibility: .visible
        ) {
            Button(String(localized: "disconnectGoogleCalendar"), role: .destructive) {
                Task { await viewModel.disconnect() }
            }
            Button(String(localized: "cancel"), role: .cancel) {}
        } message: {
            Text(String(localized: "disconnectGoogleCalendarConfirm"))
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.connectionState {
            case .idle, .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .leading)

            case .error:
                Text(String(localized: "calendarConnectionLoadFailed"))
                    .font(.footnote)
                    .foregroundColor(.errorSB)

            case .success(let connection):
                CalendarConnectionStatusRowView(connection: connection)
        }
    }

    @ViewBuilder
    private var actionButton: some View {
        if let connection = viewModel.connection, connection.isActive {
            MainButtonOutlined(
                title: String(localized: "disconnectGoogleCalendar"),
                fullWidth: true,
                onClick: { showDisconnectConfirm = true }
            )
            .disabled(viewModel.isProcessing)
        } else {
            MainButton(
                title: String(localized: "connectGoogleCalendar"),
                isDisabled: viewModel.isProcessing,
                isLoading: viewModel.isProcessing,
                onClick: { Task { await viewModel.connect() } }
            )
        }
    }
}
