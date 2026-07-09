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
    
    var body: some View {
        VStack(spacing: 0) {
            Header(title: String(localized: "bookingDetails"))
            
            if viewModel.isLoading && viewModel.uiState.data == nil {
                Spacer()
                ProgressView()
                    .tint(.primarySB)
                Spacer()
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text(errorMessage)
                        .foregroundColor(.errorSB)
                        .multilineTextAlignment(.center)
                    
                    Button(String(localized: "retry")) {
                        Task { await viewModel.refresh() }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .frame(maxHeight: .infinity)
            } else if let a = viewModel.uiState.data {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        AppointmentDetailsHeader(appointment: a)
                        
                        Text("\(String(localized: "bookedServices")):")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.vertical, .xl)
                        
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
                        .padding(.bottom, .xl)
                        
                        AppointmentDetailsActions(
                            status: a.status,
                            isCustomer: a.isCustomer,
                            onNavigateToCancel: {}
                        )
                        .padding(.bottom, .xl)
                        
                        if !a.hasWrittenReview && viewModel.isFinished && a.isCustomer {
                            ReviewCTA { _ in }
                            .padding(.bottom, 24)
                        }
                        
                        if let rev = a.writtenReview {
                            AppointmentDetailsWrittenReview(
                                customerAvatar: a.customer.avatar ?? "",
                                isCustomer: a.isCustomer,
                                review: rev.review,
                                rating: rev.rating,
                                onOpenCancelSheet: {}
                            )
                        }
                        
                        if let message = a.message {
                            Text(message)
                                .font(.body)
                                .padding(.top, 8)
                        }
                        
                        Spacer().frame(height: 16)
                    }
                    .padding(.horizontal, .xl)
                }
                .refreshable {
                    await viewModel.refresh()
                }
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
