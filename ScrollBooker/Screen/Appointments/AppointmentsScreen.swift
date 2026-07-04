//
//  AppointmentsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct AppointmentsScreen: View {
    @EnvironmentObject var router: Router
    @StateObject private var viewModel: AppointmentsViewModel
    
    var onNavigateToAppointmentDetails: (Int) -> Void
    
    init(
        viewModel: AppointmentsViewModel,
        onNavigateToAppointmentDetails: @escaping (Int) -> Void = { _ in }
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onNavigateToAppointmentDetails = onNavigateToAppointmentDetails
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Header(
                title: String(localized: "bookings"),
                enableBack: false
            )
            
            ScrollView {
                Group {
                    switch viewModel.state {
                    case .idle:
                        Color.clear
                            .frame(height: 200)
                        
                    case .loading:
                        // Loader centralizat fluid
                        VStack {
                            Spacer()
                            ProgressView()
                                .scaleEffect(1.2)
                            Spacer()
                        }
                        .frame(minHeight: 400)
                        
                    case .error(let message):
                        // Ecran de eroare integrat safe în scroll
                        VStack(spacing: 16) {
                            Text("❌")
                                .font(.system(size: 40))
                            Text(message)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                            
                            Button(action: {
                                Task { await viewModel.refresh() }
                            }) {
                                Text("retry")
                                    .font(.subheadline.bold())
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.top, 60)
                        
                    case .success(let appointments):
                        if appointments.isEmpty {
                            VStack {
                                Text("Nu ai nicio programare activă.")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top, 100)
                        } else {
                            // Randerul performant de listă binară
                            LazyVStack(spacing: 0) {
                                ForEach(appointments) { item in
                                    AppointmentCardView(
                                        appointment: item,
                                        onClick: {
                                            onNavigateToAppointmentDetails(item.id)
                                        }
                                    )
                                    .onAppear {
                                        Task { await viewModel.loadMoreIfNeeded(currentAppointment: item) }
                                    }
                                    
                                    Divider()
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .refreshable {
                // Pull-to-Refresh asincron nativ legat direct la ScrollView-ul global
                await viewModel.refresh()
            }
        }
        .task {
            await viewModel.initialLoadIfNeeded()
        }
    }
}

//#Preview("Light") {
//    AppointmentsScreen(
//        viewModel: AppointmentsViewModel(api: <#T##any AppointmentAPI#>, session: SessionManager),
//        onNavigateToAppointmentDetails: {_ in }
//    )
//}
//
//#Preview("Dark") {
//    AppointmentsScreen(
//        onNavigateToAppointmentDetails: {_ in }
//    )
//        .preferredColorScheme(.dark)
//}
