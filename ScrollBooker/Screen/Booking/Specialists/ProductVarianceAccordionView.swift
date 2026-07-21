//
//  ProductVarianceAccordionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct PriceVarianceAccordionView: View {
    let employees: [BookingFlowUser]
    let item: SelectedBookingItem
    let selectedEmployeeId: Int?
    
    @State private var isExpanded: Bool = false
    
    private var accordionHeader: some View {
        HStack {
            Text("Prețurile serviciului diferă în funcție de specialist")
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .contentShape(Rectangle())
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                isExpanded.toggle()
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            accordionHeader
            
            if isExpanded {
                let offeringsMap = Dictionary(uniqueKeysWithValues: item.offerings.map { ($0.user.id, $0) })
                
                VStack(spacing: 6) {
                    ForEach(employees) { emp in
                        let offering = offeringsMap[emp.id]
                        let isCurrentlySelected = emp.id == selectedEmployeeId
                        
                        ProductEmployeeOfferingView(
                            isSelected: isCurrentlySelected,
                            employee: emp,
                            offering: offering
                        )
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(.label).opacity(0.04))
        .cornerRadius(12)
    }
}
