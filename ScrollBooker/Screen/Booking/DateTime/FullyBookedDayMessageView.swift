//
//  FullyBookedDayMessageView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import SwiftUI

struct FullyBookedDayMessageView: View {
    var onNextOpenDayTap: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color.surfaceSB)
                    .frame(width: 60, height: 60)
                
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 28, weight: .light))
                    .foregroundColor(.onBackgroundSB)
            }
            .padding(.top, 50)
            
            Spacer().frame(height: 24)
            
            Text("Ai ajuns prea târziu")
                .font(.system(size: 19))
                .fontWeight(.semibold)
                .foregroundColor(.onBackgroundSB)
                .multilineTextAlignment(.center)
            
            Spacer().frame(height: 8)
            
            Text("Toate intervalele orare pentru această zi au fost deja ocupate de alți clienți.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer().frame(height: 24)
            
            Button(action: {
                onNextOpenDayTap()
            }) {
                Text("Următoarea zi disponibilă")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.dividerSB, lineWidth: 1)
                    )
            }
        }
        .frame(maxWidth: .infinity)
    }
}
