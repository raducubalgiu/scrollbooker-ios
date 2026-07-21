//
//  ProductOfferingCardView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct ProductOfferingCardView: View {
    let item: SelectedBookingItem
    let selectedEmployeeId: Int?
    let employees: [BookingFlowUser]
    let currentOffering: ProductOffering?
    var onRemoveItem: () -> Void
    
    private var hasOffering: Bool {
        currentOffering != nil
    }
    
    private var borderColor: Color {
        hasOffering ? Color.gray.opacity(0.3) : Color.red.opacity(0.5)
    }
    
    private var cardBgColor: Color {
        hasOffering ? Color.clear : Color.red.opacity(0.05)
    }
    
    private var formattedPrice: String {
        if let offering = currentOffering {
            return String(format: "%.2f RON", NSDecimalNumber(decimal: offering.priceWithDiscount).doubleValue)
        }
        return ""
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.productName)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.onBackgroundSB)
                    
                    Text("\(item.variantDuration) min")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if hasOffering {
                    Text(formattedPrice)
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.onBackgroundSB)
                }
            }

            statusAndActionRow

            if item.hasPriceVariance {
                PriceVarianceAccordionView(
                    employees: employees,
                    item: item,
                    selectedEmployeeId: selectedEmployeeId
                )
                .padding(.top, 4)
            }
        }
        .padding(.all, 12)
        .background(cardBgColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 1.5)
        )
    }
    
    @ViewBuilder
    private var statusAndActionRow: some View {
        let statusColor = hasOffering ? Color.green : Color.red
        
        HStack(alignment: .center) {
            HStack(spacing: 6) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 10, height: 10)
                    .background(
                        Circle()
                            .fill(statusColor.opacity(0.1))
                            .frame(width: 18, height: 18)
                    )
                
                Text(hasOffering ? "Disponibil la specialist" : "Nu oferă acest serviciu")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundColor(statusColor)
            }
            
            Spacer()
            
            if !hasOffering {
                Button(action: onRemoveItem) {
                    HStack(spacing: 4) {
                        Image(systemName: "trash")
                            .font(.system(size: 14))
                        Text(String(localized: "remove"))
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}
