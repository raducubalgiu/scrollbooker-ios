//
//  CancellationPolicyView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct CancellationPolicyView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(String(localized: "cancellationPolicy"))
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.onBackgroundSB)
                
                Text(String(localized: "cancellationPolicyDescription"))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
            .padding(.all, 24)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceSB)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.dividerSB, lineWidth: 1)
        )
    }
}
