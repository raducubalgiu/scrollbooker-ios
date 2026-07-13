//
//  ReviewsSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

struct WriteReviewSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    let initialRating: Int
    var onSubmitReview: (Int, String) async -> Void
    
    @State private var selectedRating: Int?
    @State private var reviewText: String = ""
    @State private var isSaving: Bool = false
    
    init(rating: Int, onSubmitReview: @escaping (Int, String) async -> Void) {
        self.initialRating = rating
        self.onSubmitReview = onSubmitReview
        _selectedRating = State(initialValue: rating)
    }
    
    private var dynamicRatingLabel: String {
        guard let rating = selectedRating else { return "" }
        switch rating {
        case 1: return String(localized: "rating_1")
        case 2: return String(localized: "rating_2")
        case 3: return String(localized: "rating_3")
        case 4: return String(localized: "rating_4")
        case 5: return String(localized: "rating_5")
        default: return ""
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(
                onDismiss: { dismiss() },
                title: String(localized: "writeAReview")
            )
            
            ScrollView {
                VStack(spacing: 24) {
                    AddReviewRatingView(
                        selectedRating: selectedRating,
                        onRatingClick: { newRating in
                            guard !isSaving else { return }
                            self.selectedRating = newRating
                        },
                        ratingLabel: dynamicRatingLabel
                    )
                    
                    AddReviewCaptureInputView(
                        reviewText: reviewText,
                        onValueChange: { newValue in
                            if newValue.count <= 200 {
                                self.reviewText = newValue
                            }
                        },
                        isSaving: isSaving,
                        onCreateReview: {
                            Task {
                                isSaving = true
            
                                let finalRating = selectedRating ?? initialRating
                                await onSubmitReview(finalRating, reviewText)
                                
                                isSaving = false
                                dismiss()
                            }
                        }
                    )
                }
                .padding(.horizontal, 24)
                .padding(.vertical)
            }
        }
        .background(Color.backgroundSB)
    }
}
