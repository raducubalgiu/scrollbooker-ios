//
//  BookingSpecialistsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

public struct BookingSpecialistsScreen: View {
    let viewModel: BookingViewModel
    let onBack: () -> Void
    let onNavigateToDateTime: () -> Void
    
    public var body: some View {
        VStack {
            HeaderView(onBack: onBack)
            
            VStack(spacing: 20) {
                Text("Business curent ID: \(viewModel.params.businessId)")
                    .foregroundColor(.secondary)

                Button("Mergi la Data & Ora") {
                    onNavigateToDateTime()
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
        }
    }
}
