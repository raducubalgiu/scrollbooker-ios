//
//  SpecialistSelectRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct SpecialistSelectRowView: View {
    let specialist: BookingFlowUser
    let isSelected: Bool
    var onSelect: () -> Void

    var body: some View {
        HStack(spacing: AppSize.base.rawValue) {
            HStack(spacing: AppSize.m.rawValue) {
                AvatarWithRatingView(
                    url: specialist.avatarURL,
                    rating: specialist.ratingsAverage,
                    size: .l,
                    onClick: onSelect
                )

                VStack(alignment: .leading, spacing: AppSize.xxs.rawValue) {
                    Text(specialist.fullName)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.onBackgroundSB)

                    Text(specialist.profession)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: onSelect)

            Spacer()

            Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                .font(.title3)
                .foregroundColor(isSelected ? .onBackgroundSB : .dividerSB)
                .onTapGesture(perform: onSelect)
        }
    }
}
