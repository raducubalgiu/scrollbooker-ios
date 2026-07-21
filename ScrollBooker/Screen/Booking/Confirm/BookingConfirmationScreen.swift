//
//  BookingConfirmationScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

public struct BookingConfirmationScreen: View {
    @State var viewModel: BookingViewModel
    let onBack: () -> Void
    let onAppointmentCreated: () -> Void
    
    public var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: "",
                onBack: onBack
            )
            
            switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()
                    
                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.loadBookingFlow() }
                    }
                    
                case .success(let bookingFlow):
                    BookingConfirmationSuccessView(
                        bookingFlow: bookingFlow,
                        viewModel: viewModel,
                        onAppointmentCreated: onAppointmentCreated
                    )
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundSB)
    }
}
