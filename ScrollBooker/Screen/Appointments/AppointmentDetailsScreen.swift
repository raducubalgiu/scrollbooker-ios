//
//  AppointmentDetailsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.08.2025.
//

import SwiftUI

struct AppointmentDetailsScreen: View {
    @Bindable var viewModel: AppointmentDetailsViewModel
    @State private var activeSheet: AppointmentDetailsSheet? = nil
    var onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: String(localized: "bookingDetails"),
                onBack: onBack
            )
            
            VStack {
                switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()
                    
                case .error:
                    ErrorView(message: String(localized: "somethingWentWrong")) {
                        Task { await viewModel.refresh() }
                    }
                    
                case .success(let appointment):
                    AppointmentDetailsSuccessView(
                        appointment: appointment,
                        isSaving: viewModel.isSaving,
                        isFinished: viewModel.isFinished,
                        onOpenCancelSheet: {
                            self.activeSheet = .cancelAppointment
                        },
                        onOpenReviewSheet: { rating in
                            self.activeSheet = .writeReview(rating: rating)
                        },
                        onRefresh: {
                            await viewModel.refresh()
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.backgroundSB)
        .navigationBarHidden(true)
        .task {
            await viewModel.loadAppointment()
        }
        .sheet(item: $activeSheet) { sheetType in
            if let appointmentData = viewModel.viewState.data {
                switch sheetType {
                case .writeReview(let rating):
                    WriteReviewSheetView(rating: rating) { selectedRating, message in
                        guard let userId = appointmentData.user.id else { return }
                        let productId = appointmentData.products.first?.id ?? 0
                        
                        self.activeSheet = nil
                        await viewModel.createReview(
                            review: message,
                            rating: selectedRating,
                            userId: userId,
                            productId: productId
                        )
                    }
                    
                case .cancelAppointment:
                    CancelAppointmentSheetView { finalReason in
                        self.activeSheet = nil
                        await viewModel.cancelCurrentAppointment(reason: finalReason)
                    }
                }
            }
        }
    }
}

