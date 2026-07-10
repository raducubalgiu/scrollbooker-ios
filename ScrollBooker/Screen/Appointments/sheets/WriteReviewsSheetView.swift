//
//  ReviewsSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

struct WriteReviewSheetView: View {
    @Environment(\.dismiss) private var dismiss
    let rating: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Review pentru \(rating) stele")
                .font(.headline)
            
            Button("Închide") {
                dismiss()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
