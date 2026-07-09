//
//  AppointmentDetailsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.08.2025.
//

import SwiftUI
import MapKit

struct AppointmentDetailsScreen: View {
    let appointmentId: Int
    let isFinished: Bool
    
    private var appointment: Appointment? {
        appointmentsList.first { $0.id == appointmentId }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                Header(title: "")
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if let a = appointment {
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
                            
                            // Review CTA Box
                            if !a.hasWrittenReview && isFinished && a.isCustomer {
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
                        }
                        
                        Spacer().frame(height: 16)
                    }
                    .padding(.horizontal, .xl)
                }
            }
            .background(Color.backgroundSB)
            .navigationBarHidden(true)
        }
}

#Preview("Light") {
    AppointmentDetailsScreen(
        appointmentId: 1,
        isFinished: true
    )
}

#Preview("Dark") {
    AppointmentDetailsScreen(
        appointmentId: 1,
        isFinished: true
    )
        .preferredColorScheme(.dark)
}
