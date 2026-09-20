//
//  AppointmentDetailsSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

enum AppointmentDetailsSheet: Identifiable {
    case writeReview(rating: Int)
    case cancelAppointment
    case reviewOptions(review: AppointmentWrittenReview)
    case editReview(review: AppointmentWrittenReview)
    case deleteReviewConfirm(reviewId: Int)

    var id: String {
        switch self {
        case .writeReview(let rating): "review_\(rating)"
        case .cancelAppointment: "cancel"
        case .reviewOptions(let review): "reviewOptions_\(review.id)"
        case .editReview(let review): "editReview_\(review.id)"
        case .deleteReviewConfirm(let reviewId): "deleteReview_\(reviewId)"
        }
    }
}
