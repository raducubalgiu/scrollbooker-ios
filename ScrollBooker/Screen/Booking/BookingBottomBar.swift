//
//  BookingBottomBar.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct BookingBottomBar: View {
    let bookingTotals: BookingTotals
    var onNext: () -> Void
    let isEnabled: Bool
    let isVisible: Bool
    
    var body: some View {
        Group {
            if isVisible {
                VStack(spacing: 0) {
                    Divider()
                        .background(Color.dividerSB)
                        .frame(height: 0.55)
                    
                    HStack(alignment: .center, spacing: 16) {
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(format: "%.2f RON", NSDecimalNumber(decimal: bookingTotals.totalPrice).doubleValue))
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.onBackgroundSB)
                                .lineLimit(1)
                            
                            Text("\(bookingTotals.totalDuration)min")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        Button(action: onNext) {
                            Text("Înainte")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .background(isEnabled ? Color.primarySB : Color.gray.opacity(0.5))
                                .cornerRadius(50)
                        }
                        .disabled(!isEnabled)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    .background(Color(uiColor: .systemBackground))
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}
