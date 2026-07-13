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
                switch viewModel.viewState {
                    case .idle, .loading:
                        LoadingView()
                        
                    case .error(let message):
                        ErrorView(message: message) {
                            Task { await viewModel.refresh() }
                        }
                        
                    case .empty:
                        NoDataView(
                            title: String(localized: "bookings"),
                            message: String(localized: "notFoundAppointments"),
                            systemImage: "calendar.badge.clock"
                        )
                        
                    case .success(let appointments):
                        AppointmentsListView(
                            appointments: appointments,
                            isPaging: viewModel.isPaging,
                            onNavigateToAppointmentDetails: onNavigateToAppointmentDetails,
                            onItemAppear: { appointment in
                                Task {
                                    await viewModel.loadMoreIfNeeded(currentAppointment: appointment)
                                }
                            },
                            onRefresh: {
                                await viewModel.refresh()
                            }
                        )
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            await viewModel.initialLoadIfNeeded()
        }
    }
}
