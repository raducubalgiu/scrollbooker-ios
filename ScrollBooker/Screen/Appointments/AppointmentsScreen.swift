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
                    VStack {
                        Spacer()

                        ProgressView()
                            .scaleEffect(1.2)

                        Spacer()
                    }
                    .frame(minHeight: 400)

                } else if let error = viewModel.uiState.errorMessage {
                    VStack(spacing: 16) {
                        Text("❌")
                            .font(.system(size: 40))

                        Text(error)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)

                        Button("Retry") {
                            Task {
                                await viewModel.refresh()
                            }
                        }
                        .buttonStyle(.borderedProminent)

                    }
                    .padding(.top, 60)

                } else if viewModel.uiState.data.isEmpty {
                    VStack {

                        Text("Nu ai nicio programare activă.")
                            .foregroundColor(.secondary)

                    }
                    .padding(.top, 100)

                } else {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.uiState.data) { appointment in
                            AppointmentCardView(
                                appointment: appointment,
                                onClick: {
                                    onNavigateToAppointmentDetails(
                                        appointment.id
                                    )
                                }
                            )
                            .onAppear {
                                Task {
                                    await viewModel.loadMoreIfNeeded(
                                        currentAppointment: appointment
                                    )
                                }
                            }

                            Divider()

                        }

                    }

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
