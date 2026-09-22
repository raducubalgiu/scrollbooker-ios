//
//  BusinessProfileTabRow.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessProfileTabRow: View {
    @Binding var selected: BusinessProfileSection
    var onSelect: (BusinessProfileSection) -> Void
    
    @Namespace private var indicatorNS
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(BusinessProfileSection.allCases) { section in
                let isSel = section == selected
                
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        onSelect(section)
                    }
                }) {
                    VStack(spacing: 0) {
                        Spacer()
                        
                        Text(section.title)
                            .font(.system(size: 15, weight: isSel ? .bold : .semibold))
                            .foregroundColor(isSel ? .primary : .gray)
                            .padding(.bottom, 12)
                        
                        if isSel {
                            Capsule()
                                .fill(Color.primary)
                                .frame(height: 3)
                                .matchedGeometryEffect(id: "activeTabIndicator", in: indicatorNS)
                        } else {
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 3)
                        }
                    }
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 8)
    }
}
