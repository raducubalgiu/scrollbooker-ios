//
//  AppointmentCard.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.08.2025.
//

import SwiftUI

struct AppointmentCard: View {
    var padding: CGFloat = 16
    
    let appointment: Appointment
    let onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            VStack(alignment: .leading) {
                Text(appointment.status)
                    .font(.headline.bold())
                    .foregroundColor(.gray)
                    .padding(.bottom, .base)
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 15) {
                            AvatarView(
                                imageURL: appointment.user.avatarURL,
                                size: .l
                            )
                            VStack(alignment: .leading) {
                                Text(appointment.user.fullName)
                                    .font(.headline.bold())
                                Text(appointment.user.profession ?? "-")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Text(appointment.product.name)
                            .font(.headline)
                            .foregroundColor(.gray)
                            
                        Text("\(appointment.product.priceWithDiscount) \(appointment.product.currency)")
                            .font(.headline.bold())
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 7) {
                        Text(appointment.startDate.day)
                            .font(.title2.bold())
                        Text(appointment.startDate.month)
                            .foregroundColor(.gray)
                        Text(appointment.startDate.time)
                            .font(.title3.bold())
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.divider, lineWidth: 1)
                    )
                }
            }
            .frame(maxWidth: .infinity)
            .padding(padding)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview("Light") {
    AppointmentCard(
        appointment: appointmentsList[0],
        onClick: {}
    )
}

#Preview("Dark") {
    AppointmentCard(
        appointment: appointmentsList[0],
        onClick: {}
    )
        .preferredColorScheme(.dark)
}

