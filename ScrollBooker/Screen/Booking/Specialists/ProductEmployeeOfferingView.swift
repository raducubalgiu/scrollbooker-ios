//
//  ProductEmployeeOfferingView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct ProductEmployeeOfferingView: View {
    let isSelected: Bool
    let employee: BookingFlowUser
    let offering: ProductOffering?
    
    private var rowAlpha: Double {
        offering != nil ? 1.0 : 0.4
    }
    
    private var rowBgColor: Color {
        isSelected ? Color.accentColor.opacity(0.08) : Color.clear
    }
    
    private var displayName: String {
        isSelected ? "\(employee.fullName) (selectat)" : employee.fullName
    }
    
    private var formattedPrice: String {
        if let price = offering?.priceWithDiscount {
            return String(format: "%.2f RON", NSDecimalNumber(decimal: price).doubleValue)
        }
        return "N/A"
    }
    
    var body: some View {
        HStack(alignment: .center) {
            HStack(spacing: 8) {
                AvatarView(
                    imageURL: employee.avatarURL,
                    size: .l
                )
                
                Text(displayName)
                    .font(.system(size: 14))
                    .fontWeight(isSelected ? .bold : .medium)
                    .foregroundColor(.onBackgroundSB)
            }
            
            Spacer()
            
            Text(formattedPrice)
                .font(.system(size: 14))
                .fontWeight(.bold)
                .foregroundColor(.onBackgroundSB)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(rowBgColor)
        .cornerRadius(8)
        .opacity(rowAlpha)
    }
}
