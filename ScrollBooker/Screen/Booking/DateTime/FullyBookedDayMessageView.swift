//
//  FullyBookedDayMessageView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import SwiftUI

struct FullyBookedDayMessageView: View {
    var onNextOpenDayTap: (() -> Void)? = nil

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
            
            Text(String(localized: "youArrivedToLate"))
                .font(.system(size: 19))
                .fontWeight(.semibold)
                .foregroundColor(.onBackgroundSB)
                .multilineTextAlignment(.center)

            Spacer().frame(height: 8)

            Text(String(localized: "bookingFullyBookedDayMessage"))
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if let onNextOpenDayTap {
                Spacer().frame(height: 24)

                Button(action: onNextOpenDayTap) {
                    Text(String(localized: "nextOpenDay"))
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
        }
        .frame(maxWidth: .infinity)
    }
}
