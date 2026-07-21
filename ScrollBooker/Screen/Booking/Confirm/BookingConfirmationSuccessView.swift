//
//  BookingConfirmationSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct BookingConfirmationSuccessView: View {
    let bookingFlow: BookingFlow
    let viewModel: BookingViewModel
    let onAppointmentCreated: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: AppSize.base.rawValue
            ) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(localized: "checkDetails"))
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.onBackgroundSB)
                    
                    Text(String(localized: "checkAppointmentDetailsDescriptiom"))
                        .font(.body)
                        .foregroundColor(.gray)
                }
                
                BookingSummaryView(
                    startDate: "2025-05-23",
                    totalDuration: viewModel.bookingTotals.totalDuration,
                    owner: bookingFlow.business.owner,
                    address: bookingFlow.business.formattedAddress
                )
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "selectedServices"))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray)
                    
                    ConfirmServicesView(
                        selectedBookingItems: viewModel.selectedBookingItems,
                        selectedEmployeeId: viewModel.selectedEmployeeId,
                        totals: viewModel.bookingTotals
                    )
                }
                
                CancellationPolicyView()
            }
            .padding(.all, .base)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack {
                Divider()
                
                MainButton(
                    title: String(localized: "confirmReservation"),
                    onClick: onAppointmentCreated
                )
                .padding(.top, .s)
                .padding(.horizontal, .base)
            }
            .background(Color.backgroundSB)
        }
    }
}
