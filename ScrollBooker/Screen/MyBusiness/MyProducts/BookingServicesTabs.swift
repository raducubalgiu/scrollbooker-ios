//
//  BookingServicesTabs.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.07.2026.
//

import SwiftUI

struct BookingServicesTabs: View {
    let activeSectionId: Int
    let serviceGroups: [BusinessServicesWithProducts]
    let onTabSelect: (Int) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                // Specificăm id: \.service.id în mod explicit
                ForEach(serviceGroups, id: \.service.id) { group in
                    let isSelected = group.service.id == activeSectionId
                    
                    VStack(spacing: 8) {
                        Text(group.service.name)
                            .font(.system(size: 14, weight: isSelected ? .bold : .regular))
                            .foregroundColor(isSelected ? .primary : .gray)
                        
                        Rectangle()
                            .fill(isSelected ? .primary : Color.clear)
                            .frame(height: 2)
                    }
                    .onTapGesture {
                        onTabSelect(group.service.id)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }
}
