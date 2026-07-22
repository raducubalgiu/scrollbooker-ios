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
    
    private static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return formatter
    }()
    
    private static let backupFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private var formattedSelectedSlot: String {
        guard let slotString = viewModel.selectedSlot?.startDateLocale, !slotString.isEmpty else {
            return "N/A"
        }
        
        guard let date = Self.iso8601Formatter.date(from: slotString) ??
                          Self.backupFormatter.date(from: slotString) else {
            let components = slotString.components(separatedBy: "T")
            if components.count > 1, let datePart = components.first, let timePart = components.last?.prefix(5) {
                return "\(datePart) \(timePart)"
            }
            return slotString
        }
        return date.formatted(
            .dateTime
                .day(.defaultDigits)
                .month(.abbreviated)
                .year(.twoDigits)
                .hour(.twoDigits(amPM: .omitted))
                .minute(.twoDigits)
        )
    }
    
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
                    startDate: formattedSelectedSlot,
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
                    isDisabled: viewModel.isSaving,
                    isLoading: viewModel.isSaving,
                    onClick: onAppointmentCreated,
                )
                .padding(.top, .s)
                .padding(.horizontal, .base)
            }
            .background(Color.backgroundSB)
        }
    }
}
