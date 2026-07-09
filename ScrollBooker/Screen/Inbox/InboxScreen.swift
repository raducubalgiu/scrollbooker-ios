//
//  InboxScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct InboxScreen: View {
    @State private var viewModel: InboxViewModel

    init(viewModel: InboxViewModel) {
        _viewModel = State(initialValue: viewModel)

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
                        ForEach(viewModel.uiState.data) { notification in
                            NotificationItemView(
                                notification: notification,
                                onNavigateToUserProfile: { _ in },
                                onNavigateToEmploymentRequest: { _ in },
                                onNavigateToAppointmentDetails: { _ in }
                            )
                            .onAppear {
                                Task {
                                    await viewModel.loadMoreIfNeeded(
                                        currentNotification: notification
                                    )
                                }
                            }
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

//#Preview("Light") {
//    InboxScreen(
//        //onNavigateToEmployment: {}
//    )
//}
//
//#Preview("Dark") {
//    InboxScreen(
//        //onNavigateToEmployment: {}
//    )
//        .preferredColorScheme(.dark)
//}
