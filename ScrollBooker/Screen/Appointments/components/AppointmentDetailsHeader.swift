//
//  AppointmentDetailsHeader.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import SwiftUI

struct AppointmentDetailsHeader: View {
    let appointment: Appointment

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 16)

            Text(appointment.status.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(appointment.status.color)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(appointment.status.color.opacity(0.2))
                .cornerRadius(8)

            Spacer().frame(height: 16)

            VStack(alignment: .leading, spacing: 8) {
                Text(appointment.startDate.display())
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("(\(appointment.totalDuration) min)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer().frame(height: 24)

            HStack(spacing: 12) {
                if let rating = appointment.displayedPerson.ratingsAverage {
                    AvatarWithRatingView(
                        url: appointment.displayedPerson.avatarURL,
                        rating: rating,
                        size: .xl,
                        onClick: {}
                    )
                } else {
                    AvatarView(
                        imageURL: appointment.displayedPerson.avatarURL,
                        size: .xl,
                        border: AvatarView.AvatarBorder(color: .dividerSB, width: 1)
                    )
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.displayedPerson.fullName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)

                    if let subtitle = subtitle(for: appointment.displayedPerson) {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }

                Spacer()
            }

            if !appointment.isCustomer {
                HStack(spacing: 8) {
                    Text(String(localized: "specialist"))
                        .font(.caption)
                        .foregroundColor(.gray)

                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.caption2)
                        .foregroundColor(.gray)

                    AvatarGroupView(
                        avatarURLs: [
                            appointment.business.businessOwnerAvatarURL,
                            appointment.user.avatarURL
                        ]
                    )

                    Text(appointment.user.fullName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                .padding(.vertical, .xl)
            }
        }
    }

    private func subtitle(for person: AppointmentUser) -> String? {
        var parts: [String] = []

        if let profession = person.profession, !profession.isEmpty {
            parts.append(profession)
        }

        if let ratingsCount = person.ratingsCount {
            parts.append("\(ratingsCount) \(String(localized: "reviews"))")
        }

        return parts.isEmpty ? nil : parts.joined(separator: " • ")
    }
}
