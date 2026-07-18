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
                            .padding(.bottom, 12) // Padding curat sub text
                        
                        // REZOLVARE ANIMAȚIE: Randăm ierarhia curat fără ZStack sau else structural
                        if isSel {
                            Capsule()
                                .fill(Color.primary) // Sau culoarea brandului tău
                                .frame(height: 3)
                                // matchedGeometryEffect are nevoie de un ID unic și de Namespace-ul tău
                                .matchedGeometryEffect(id: "activeTabIndicator", in: indicatorNS)
                        } else {
                            // Această linie transparentă menține înălțimea fixă fără a strica Namespace-ul
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 3)
                        }
                    }
                }
                .buttonStyle(.plain) // Elimină efectul nativ de opacitate la click de pe butoane
                .frame(maxWidth: .infinity) // Împarte ecranul în mod egal pentru cele 5 taburi
            }
        }
        .padding(.horizontal, 8)
    }
}
