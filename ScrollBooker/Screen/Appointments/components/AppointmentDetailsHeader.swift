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
            Text(appointment.status.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(appointment.status.color)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(appointment.status.color.opacity(0.2))
                .cornerRadius(8)
            
            Spacer().frame(height: 24)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("2025-05-23")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("(\(appointment.totalDuration) min)")
                    .font(.body)
                    .foregroundColor(.gray)
            }
            
            Spacer().frame(height: 24)
            
            HStack(spacing: 12) {
                if let rating = appointment.user.ratingsAverage {
                    AvatarWithRatingView(
                        url: appointment.user.avatarURL,
                        rating: rating,
                        size: .l,
                        onClick: {}
                    )
                } else {
                    AvatarView(
                        imageURL: appointment.user.avatarURL,
                        size: .l,
                        border: AvatarView.AvatarBorder(color: .divider, width: 1)
                    )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.user.fullName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    HStack {
                        if let profession = appointment.user.profession, !profession.isEmpty {
                            Text("\(profession) • ")
                        }
                        
                        Text("\(appointment.user.ratingsCount ?? 0) \("reviews")")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                }
                
                Spacer()
            }
        }
    }
}
