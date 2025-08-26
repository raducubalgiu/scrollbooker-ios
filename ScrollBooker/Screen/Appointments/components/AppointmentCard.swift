//
//  AppointmentCard.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.08.2025.
//

import SwiftUI

struct AppointmentCard: View {
    var padding: CGFloat = 16
    let onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            VStack(alignment: .leading) {
                Text("Finalizat")
                    .font(.headline.bold())
                    .foregroundColor(.gray)
                    .padding(.bottom, .base)
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 15) {
                            AvatarView(
                                imageURL: URL(string: "https://media.scrollbooker.ro/avatar-male-9.jpeg"),
                                size: .l
                            )
                            VStack(alignment: .leading) {
                                Text("Radu Ion")
                                    .font(.headline.bold())
                                Text("Frizer")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Text("Tuns Barba")
                            .font(.headline)
                            .foregroundColor(.gray)
                            
                        Text("20 RON")
                            .font(.headline.bold())
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 7) {
                        Text("12")
                            .font(.title2.bold())
                        Text("August")
                            .foregroundColor(.gray)
                        Text("12:30")
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
    AppointmentCard(onClick: {})
}

#Preview("Dark") {
    AppointmentCard(onClick: {})
        .preferredColorScheme(.dark)
}

