//
//  CalendarActionsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import SwiftUI

struct CalendarActionsView: View {
    let period: String
    let enableBack: Bool
    let enableNext: Bool
    var handlePreviousWeek: () -> Void
    var handleNextWeek: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
                
                Text(period)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: {
                    if enableBack { handlePreviousWeek() }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                        .frame(width: 36, height: 36)
                        .foregroundColor(enableBack ? .onBackgroundSB.opacity(0.8) : .gray.opacity(0.3))
                        .background(Color.clear)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(enableBack ? Color.gray.opacity(0.3) : Color.clear, lineWidth: 1)
                        )
                        .contentShape(Circle())
                }
                .disabled(!enableBack)
                
                Button(action: {
                    if enableNext { handleNextWeek() }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .frame(width: 36, height: 36)
                        .foregroundColor(enableNext ? .onBackgroundSB.opacity(0.8) : .gray.opacity(0.3))
                        .background(Color.clear)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(enableNext ? Color.gray.opacity(0.3) : Color.clear, lineWidth: 1)
                        )
                        .contentShape(Circle())
                }
                .disabled(!enableNext)
            }
        }
        .padding(.horizontal, .base)
        .frame(maxWidth: .infinity)
    }
}
