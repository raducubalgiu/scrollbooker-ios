//
//  EmploymentConsentView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import SwiftUI

struct EmploymentConsentView: View {
    let text: String
    
    @Binding var isTermsAccepted: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(text)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.surfaceSB)
            )
            
            Button(action: {
                withAnimation(.easeIn(duration: 0.15)) {
                    isTermsAccepted.toggle()
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: isTermsAccepted ? "checkmark.square.fill" : "square")
                        .font(.title3)
                        .foregroundColor(isTermsAccepted ? .primarySB : Color(.tertiaryLabel))
                    
                    Text(String(localized: "acceptTermsAndConditions"))
                        .font(.footnote)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                }
                .padding(.top, .m)
            }
            .buttonStyle(.plain)
        }
    }
}
