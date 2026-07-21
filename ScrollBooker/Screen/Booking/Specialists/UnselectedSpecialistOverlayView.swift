//
//  UnselectedSpecialistOverlayView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct UnselectedSpecialistOverlay: View {
    var body: some View {
        VStack {
            Text("Te rugăm să alegi un specialist pentru a vedea disponibilitatea.")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.all, 24)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.label).opacity(0.02))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    Color.gray,
                    style: StrokeStyle(
                        lineWidth: 2,
                        dash: [10, 10]
                    )
                )
        )
        .padding(.all, 24)
    }
}
