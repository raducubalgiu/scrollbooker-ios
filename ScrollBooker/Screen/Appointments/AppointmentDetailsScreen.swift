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
                    
                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.refresh() }
                    }
                    
                case .success(let appointment):
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            AppointmentDetailsHeader(appointment: appointment)
                            
                            Text("\(String(localized: "bookedServices")):")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.vertical, .base)
                            
                            ForEach(Array(appointment.products.enumerated()), id: \.offset) { index, prod in
                                AppointmentProductPrice(
                                    name: prod.name,
                                    price: prod.price,
                                    priceWithDiscount: prod.priceWithDiscount,
                                    discount: prod.discount,
                                    currencyName: prod.currency.name
                                )
                                
                                if index < appointment.products.count - 1 {
                                    Divider()
                                        .padding(.vertical, .base)
                                }
                            }
                            
                            Divider()
                                .padding(.vertical, .base)
                            
                            AppointmentProductPrice(
                                name: String(localized: "total"),
                                price: appointment.totalPrice,
                                priceWithDiscount: appointment.totalPriceWithDiscount,
                                discount: appointment.totalDiscount,
                                currencyName: appointment.paymentCurrency.name
                            )
                            .padding(.bottom, .base)
                            
                            AppointmentDetailsActions(
                                appointmentId: appointment.id,
                                status: appointment.status,
                                isCustomer: appointment.isCustomer,
                                onOpenCancelSheet: { _ in
                                    self.activeSheet = .cancelAppointment
                                }
                            )
                            .padding(.bottom, .base)
                            
                            if !appointment.hasWrittenReview && viewModel.isFinished && appointment.isCustomer {
                                ReviewCTA { rating in
                                    self.activeSheet = .writeReview(rating: rating)
                                }
                                .padding(.bottom, .base)
                            }
                            
                            if let rev = appointment.writtenReview {
                                AppointmentDetailsWrittenReview(
                                    customerAvatar: appointment.customer.avatar ?? "",
                                    isCustomer: appointment.isCustomer,
                                    review: rev.review,
                                    rating: rev.rating,
                                    onOpenCancelSheet: {}
                                )
                                .padding(.bottom, .base)
                            }
                            
                            if let message = appointment.message {
                                Text(message)
                                    .font(.body)
                                    .padding(.top, 8)
                            }
                            
                            SectionMap(
                                mapUrl: appointment.business.mapUrl ?? "",
                                coordinates: appointment.business.coordinates,
                                fullName: appointment.user.fullName
                            )
                        }
                        .padding(.horizontal, .xl)
                    }
                    .refreshable {
                        await viewModel.refresh()
                    }
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
            if let appointmentData = viewModel.uiState.data {
                switch sheetType {
                    case .writeReview(let rating):
                        WriteReviewSheetView(rating: rating) { selectedRating, message in
                            guard let userId = appointmentData.user.id else {
                                viewModel.errorMessage = "User ID is missing"
                                return
                            }
                            
                            let productId = appointmentData.products.first?.id ?? 0
                            
                            await viewModel.createReview(
                                review: message,
                                rating: selectedRating,
                                userId: userId,
                                productId: productId
                            )
                        }
                        
                    case .cancelAppointment:
                        CancelAppointmentSheetView { finalReason in
                            await viewModel.cancelCurrentAppointment(reason: finalReason)
                        }
                    }
            }
        }
    }
}
