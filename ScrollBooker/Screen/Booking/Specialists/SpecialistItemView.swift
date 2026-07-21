//
//  SpecialistItemView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct SpecialistItemView: View {
    let isSelected: Bool
    let specialist: BookingFlowUser
    var withBadge: Bool = true
    var size: AvatarView.AvatarSize = .s
    
    var body: some View {
        HStack(spacing: 16) {
            if withBadge {
                AvatarWithRatingView(
                    url: specialist.avatarURL,
                    rating: specialist.ratingsAverage,
                    size: size,
                    onClick: {}
                )
            } else {
                AvatarView(
                    imageURL: specialist.avatarURL,
                    size: size
                )
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(specialist.fullName)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(
            isSelected ? Color.primarySB.opacity(0.2) : Color.clear
        )
        .cornerRadius(8)
    }
}
