//
//  AppointmentsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct AppointmentsScreen: View {
    @State private var viewModel: AppointmentsViewModel
    let onNavigateToAppointmentDetails: (Int) -> Void

    init(
        viewModel: AppointmentsViewModel,
        onNavigateToAppointmentDetails: @escaping (Int) -> Void = { _ in }
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onNavigateToAppointmentDetails = onNavigateToAppointmentDetails
    }

    var body: some View {
        VStack(spacing: 0) {
            Header(
                title: String(localized: "bookings"),
                enableBack: false
            )

            ScrollView {
                if viewModel.uiState.isLoading && !viewModel.uiState.isRefreshing {
                    LoadingView()
                } else if let error = viewModel.uiState.errorMessage {
                    ErrorView(message: error) {
                        Task { await viewModel.refresh() }
                    }
                } else if viewModel.uiState.data.isEmpty && !viewModel.uiState.isLoading {
                    NoDataView(
                        title: String(localized: "bookings"),
                        message: String(localized: "notFoundAppointments"),
                        systemImage: "calendar.badge.clock"
                    )
                } else {
                    AppointmentsListView(
                        appointments: viewModel.uiState.data,
                        onNavigateToAppointmentDetails: onNavigateToAppointmentDetails,
                        onItemAppear: { appointment in
                            Task {
                                await viewModel.loadMoreIfNeeded(currentAppointment: appointment)
                            }
                        }
                    )
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
        .task {
            await viewModel.initialLoadIfNeeded()
        }
    }
}
