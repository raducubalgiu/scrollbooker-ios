//
//  BookingSummaryView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct BookingSummaryView: View {
    let startDate: String
    let totalDuration: Int
    let owner: BookingFlowUser
    let address: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BookingSummaryOwnerView(owner: owner)
            
            Divider().padding(.horizontal, .base)
            
            BookingSummaryItemView(
                title: String(localized: "dateAndTime"),
                description: "\(startDate) (\(totalDuration) min)",
                systemIcon: "calendar"
            )
            
            Divider().padding(.horizontal, .base)
            
            BookingSummaryItemView(
                title: String(localized: "location"),
                description: address,
                systemIcon: "mappin.and.ellipse"
            )
        }
        .background(Color.clear)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}
