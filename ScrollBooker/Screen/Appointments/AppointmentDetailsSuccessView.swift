//
//  AppointmentDetailsSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.07.2026.
//

import SwiftUI

struct AppointmentDetailsSuccessView: View {
    let appointment: Appointment
    let isSaving: Bool
    let isFinished: Bool
    let onOpenCancelSheet: () -> Void
    let onOpenReviewSheet: (Int) -> Void
    let onRefresh: () async -> Void
    
    var body: some View {
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
                
                Group {
                    if isSaving {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, .base)
                    } else {
                        AppointmentDetailsActions(
                            appointmentId: appointment.id,
                            status: appointment.status,
                            isCustomer: appointment.isCustomer,
                            onOpenCancelSheet: { _ in
                                onOpenCancelSheet()
                            }
                        )
                        .padding(.bottom, .base)
                    }
                }
                
                if !appointment.hasWrittenReview && isFinished && appointment.isCustomer {
                    ReviewCTA { rating in
                        onOpenReviewSheet(rating)
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
            await onRefresh()
        }
        .disabled(isSaving)
    }
}
