//
//  BookingDateTimeScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

public struct BookingDateTimeScreen: View {
    @State var viewModel: BookingViewModel
    let onBack: () -> Void
    let onNavigateToConfirmation: () -> Void
    
    public var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "", onBack: onBack)
            
            Text("Alege Ora")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(.onBackgroundSB)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 16)
            
            switch viewModel.calendarHeaderState {
                case .idle, .loading:
                    LoadingView()
                    
                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.loadCalendarHeader() }
                    }
                    
                case .success(let availableDays, let allCalendarDays):
                    CalendarSuccessView(
                        availableDays: availableDays,
                        allCalendarDays: allCalendarDays,
                        viewModel: viewModel,
                        onNavigateToConfirmation: onNavigateToConfirmation
                    )
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundSB)
        .task {
            await viewModel.loadCalendarHeader()
        }
    }
}

