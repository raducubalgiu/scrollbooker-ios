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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(BusinessProfileSection.allCases) { section in
                    let isSel = section == selected
                    VStack(spacing: 10) {
                        Text(section.title)
                            .font(.body.weight(.bold))
                            .opacity(isSel ? 1 : 0.7)
                        ZStack {
                            // indicator animat
                            if isSel {
                                Capsule()
                                    .matchedGeometryEffect(id: "IND", in: indicatorNS)
                                    .frame(height: 3)
                            } else {
                                Color.clear.frame(height: 3)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onSelect(section)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview("Light") {
    @Previewable @State var selected: BusinessProfileSection = .services
    
    BusinessProfileTabRow(
        selected: $selected,
        onSelect: {_ in }
    )
}

#Preview("Dark") {
    @Previewable @State var selected: BusinessProfileSection = .services
    
    BusinessProfileTabRow(
        selected: $selected,
        onSelect: {_ in }
    )
        .preferredColorScheme(.dark)
}

