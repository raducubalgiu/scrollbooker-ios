//
//  BookingServicesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

public struct BookingServicesScreen: View {
    let viewModel: BookingViewModel
    let onBack: () -> Void
    let onNavigateToSpecialists: () -> Void
    
    public var body: some View {
        VStack {
            HeaderView(onBack: onBack)
            
            VStack(spacing: 20) {
                Text("Business curent ID: \(viewModel.params.businessId)")
                    .foregroundColor(.secondary)

                Button("Mergi la Data & Ora") {
                    onNavigateToSpecialists()
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
        }
    }
}
