//
//  AppointmentCard.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.08.2025.
//

import SwiftUI

struct AppointmentCardView: View {
    var padding: CGFloat = 16
    
    let appointment: Appointment
    let onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                Text(appointment.status.title)
                    .font(.headline.bold())
                    .foregroundColor(appointment.status.color)
                    .padding(.bottom, 4)
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 15) {
                            AvatarView(
                                imageURL: appointment.user.avatarURL,
                                size: .l
                            )
                            VStack(alignment: .leading, spacing: 2) {
                                Text(appointment.user.fullName)
                                    .font(.headline.bold())
                                Text(appointment.user.profession ?? "-")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Text(appointment.getProductNames())
                            .fontWeight(.regular)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        HStack(alignment: .center, spacing: 5) {
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                            
                            Text(appointment.formattedTotalDuration)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 4)
                        
                        HStack(alignment: .center) {
                            HStack(alignment: .center, spacing: 5) {
                                Text("\(appointment.totalPriceWithDiscount, format: .number.precision(.fractionLength(2))) \(appointment.paymentCurrency.name)")
                                    .font(.system(size: 17, weight: .semibold))
                            
                                if appointment.totalDiscount > 0 {
                                    Text(appointment.totalPrice, format: .number.precision(.fractionLength(2)))
                                        .font(.body)
                                        .strikethrough()
                                        .foregroundColor(.gray)
                                    
                                    Text("(-\(appointment.totalDiscount, format: .number.precision(.fractionLength(2)))%)")
                                        .foregroundColor(.red)
                                }
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Text(appointment.startDate.day)
                            .font(.title2.bold())
                        Text(appointment.startDate.month)
                            .foregroundColor(.gray)
                        Text(appointment.startDate.time)
                            .font(.title3.bold())
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.divider, lineWidth: 1)
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(padding)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview("Light") {
    AppointmentCardView(
        appointment: appointmentsList[0],
        onClick: {}
    )
    
    Spacer()
}

#Preview("Dark") {
    AppointmentCardView(
        appointment: appointmentsList[0],
        onClick: {}
    )
        .preferredColorScheme(.dark)
    
    Spacer()
}

