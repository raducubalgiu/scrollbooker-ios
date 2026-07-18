//
//  AddReviewCaptureInputView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

struct AddReviewCaptureInputView: View {
    let reviewText: String
    var onValueChange: (String) -> Void
    let isSaving: Bool
    var onCreateReview: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(String(localized: "howWasYourExperience"))
                .font(.title2)
                .fontWeight(.black)
                .foregroundColor(.primary)
            
            Spacer().frame(height: 4)
            
            Text(String(localized: "howWasYourExperienceDescription"))
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer().frame(height: 24)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(String(localized: "yourReview"))
                    .font(.headline)
                
                TextField(
                    String(localized: "shareSomeDetailsAboutYourExperience"),
                    text: Binding(
                        get: { reviewText },
                        set: { onValueChange($0) }
                    ),
                    axis: .vertical
                )
                .lineLimit(4, reservesSpace: true)
                .padding()
                .background(Color.surfaceSB)
                .cornerRadius(12)
                .disabled(isSaving)
                
                Spacer().frame(height: 16)
                
                MainButton(
                    title: String(localized: "add"),
                    isDisabled: isSaving,
                    isLoading: isSaving,
                    onClick: onCreateReview,
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
