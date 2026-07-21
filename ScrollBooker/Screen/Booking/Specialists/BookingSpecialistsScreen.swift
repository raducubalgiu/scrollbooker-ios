//
//  BookingSpecialistsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

public struct BookingSpecialistsScreen: View {
    @State var viewModel: BookingViewModel
    let onBack: () -> Void
    let onNavigateToDateTime: () -> Void
    
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
                BookingSpecialistsSuccessView(
                    bookingFlow: bookingFlow,
                    viewModel: viewModel,
                    onNavigateToDateTime: onNavigateToDateTime
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: viewModel.selectedBookingItems) { _, newValue in
            if newValue.isEmpty {
                onBack()
            }
        }
    }
}

