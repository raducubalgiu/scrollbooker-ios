//
//  ConfirmServicesView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct ConfirmServicesView: View {
    var selectedBookingItems: [SelectedBookingItem]
    var selectedEmployeeId: Int?
    var totals: BookingTotals
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 0) {
                ForEach(selectedBookingItems) { item in
                    let currentOffering = item.offerings.first { $0.user.id == selectedEmployeeId }
                    
                    ConfirmServiceRowView(
                        item: item,
                        offering: currentOffering
                    )

                    if selectedBookingItems.last?.id != item.id {
                        Divider()
                            .padding(.horizontal, 24)
                    }
                }
            }

            Divider()
            
            let formattedTotalPrice = String(format: "%.2f RON", NSDecimalNumber(decimal: totals.totalPrice).doubleValue)
            
            HStack {
                Text("Total")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.onBackgroundSB)
                
                Spacer()
                
                Text(formattedTotalPrice)
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                    .foregroundColor(.onBackgroundSB)
            }
            .padding(.all, 24)
        }
        .background(Color.clear)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}
