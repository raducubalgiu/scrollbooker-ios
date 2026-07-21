//
//  BookingConfirmationScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

public struct BookingConfirmationScreen: View {
    let viewModel: BookingViewModel
    let onBack: () -> Void
    let onFinishBooking: () -> Void
    
    public var body: some View {
        VStack {
            HeaderView(onBack: onBack)
            
            VStack(spacing: 20) {
                Text("CURRENT SCREEN: CONFIRMATION")
                    .foregroundColor(.secondary)
                
                Text("Business curent ID: \(viewModel.params.businessId)")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
        }
    }
}
