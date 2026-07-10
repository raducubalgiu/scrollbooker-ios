//
//  AppointmentDetailsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.08.2025.
//

import SwiftUI
import MapKit

struct AppointmentDetailsScreen: View {
    let viewModel: AppointmentDetailsViewModel
    
    @State private var activeSheet: AppointmentDetailsSheet? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            Header(title: String(localized: "bookingDetails"))
            
            if viewModel.isLoading && viewModel.uiState.data == nil {
                LoadingView()
            }

            else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    Task { await viewModel.refresh() }
                }
            }

            else if let a = viewModel.uiState.data {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        AppointmentDetailsHeader(appointment: a)
                        
                        Text("\(String(localized: "bookedServices")):")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.vertical, .base)
                        
                        ForEach(Array(a.products.enumerated()), id: \.offset) { index, prod in
                            AppointmentProductPrice(
                                name: prod.name,
                                price: prod.price,
                                priceWithDiscount: prod.priceWithDiscount,
                                discount: prod.discount,
                                currencyName: prod.currency.name
                            )
                            
                            if index < a.products.count - 1 {
                                Divider()
                                    .padding(.vertical, .base)
                            }
                        }
                        
                        Divider()
                            .padding(.vertical, .base)
                        
                        AppointmentProductPrice(
                            name: String(localized: "total"),
                            price: a.totalPrice,
                            priceWithDiscount: a.totalPriceWithDiscount,
                            discount: a.totalDiscount,
                            currencyName: a.paymentCurrency.name
                        )
                        .padding(.bottom, .base)
                        
                        AppointmentDetailsActions(
                            appointmentId: a.id,
                            status: a.status,
                            isCustomer: a.isCustomer,
                            onOpenCancelSheet: { id in
                                self.activeSheet = .cancelAppointment
                            }
                        )
                        .padding(.bottom, .base)
                        
                        if !a.hasWrittenReview && viewModel.isFinished && a.isCustomer {
                            ReviewCTA { rating in
                                self.activeSheet = .writeReview(rating: rating)
                            }
                            .padding(.bottom, .base)
                        }
                        
                        if let rev = a.writtenReview {
                            AppointmentDetailsWrittenReview(
                                customerAvatar: a.customer.avatar ?? "",
                                isCustomer: a.isCustomer,
                                review: rev.review,
                                rating: rev.rating,
                                onOpenCancelSheet: {}
                            )
                            .padding(.bottom, .base)
                        }
                        
                        if let message = a.message {
                            Text(message)
                                .font(.body)
                                .padding(.top, 8)
                        }
                        
                        SectionMap(
                            mapUrl: a.business.mapUrl ?? "",
                            coordinates: a.business.coordinates,
                            fullName: a.user.fullName,
                        )
                    }
                    .padding(.horizontal, .xl)
                }
                .refreshable {
                    await viewModel.refresh()
                }
                .sheet(item: $activeSheet) { sheetType in
                    switch sheetType {
                        case .writeReview(let rating):
                            WriteReviewSheetView(rating: rating) { selectedRating, message in
                                guard let userId = a.user.id else {
                                    viewModel.errorMessage = "User ID is missing"
                                    return
                                }
                                
                                let productId = a.products.first?.id ?? 0
                                
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

            else {
                ContentUnavailableView(
                    String(localized: "noDetailsAvailable"),
                    systemImage: "calendar.badge.exclamationmark"
                )
            }
        }
        .background(Color.backgroundSB)
        .navigationBarHidden(true)
        .task {
            await viewModel.loadAppointment()
        }
    }
}


//#Preview("Light") {
//    AppointmentDetailsScreen(
//        appointmentId: 1,
//        isFinished: true
//    )
//}
//
//#Preview("Dark") {
//    AppointmentDetailsScreen(
//        appointmentId: 1,
//        isFinished: true
//    )
//        .preferredColorScheme(.dark)
//}
