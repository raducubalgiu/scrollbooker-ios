//
//  AppointmentDetailsSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

enum AppointmentDetailsSheet: Identifiable {
    case writeReview(rating: Int)
    case cancelAppointment
    
    var id: String {
        switch self {
        case .writeReview(let rating): "review_\(rating)"
        case .cancelAppointment: "cancel"
        }
    }
}
