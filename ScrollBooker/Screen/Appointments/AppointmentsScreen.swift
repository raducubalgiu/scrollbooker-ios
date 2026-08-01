//
//  AppointmentsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct AppointmentsScreen: View {
    let viewModel: AppointmentsViewModel
    let onNavigateToAppointmentDetails: (Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: String(localized: "bookings"),
                enableBack: false,
                onBack: {}
            )

            Group {
                switch viewModel.paginator.viewState {
                    case .idle, .loading:
                        LoadingView()

                    case .error(let message):
                        ErrorView(message: message) {
                            Task { await viewModel.refresh() }
                        }

                    case .success(let appointments):
                        if appointments.isEmpty {
                            NoDataView(
                                title: String(localized: "bookings"),
                                message: String(localized: "notFoundAppointments"),
                                systemImage: "calendar.badge.clock"
                            )
                        } else {
                            AppointmentsListView(
                                appointments: appointments,
                                isPaging: viewModel.paginator.isPaging,
                                onNavigateToAppointmentDetails: onNavigateToAppointmentDetails,
                                onItemAppear: { appointment in
                                    Task { await viewModel.loadMoreIfNeeded(currentItem: appointment) }
                                },
                                onRefresh: {
                                    await viewModel.refresh()
                                }
                            )
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            await viewModel.initialLoadIfNeeded()
        }
    }
}
