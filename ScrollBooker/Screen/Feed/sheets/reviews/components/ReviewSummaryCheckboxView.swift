//
//  ReviewSummaryCheckboxView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

struct ReviewSummaryCheckbox: View {
    let rating: Int
    let progress: CGFloat
    let count: Int
    let isEnabled: BooleanLiteralType
    let isChecked: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                if isChecked {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 18, height: 18)
            .background(
                Group {
                    if !isEnabled {
                        Color.dividerSB
                    } else if isChecked {
                        Color.primarySB
                    } else {
                        Color.clear
                    }
                }
            )
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                        !isEnabled ? Color.dividerSB : (isChecked ? Color.primarySB : Color.dividerSB),
                        lineWidth: 1
                    )
            )
            .contentShape(Rectangle())
            .onTapGesture {
                if isEnabled { onTap() }
            }
            
            Text("\(rating)")
                .font(.body)
                .bold()
                .frame(width: 16, alignment: .trailing)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 5)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.primarySB)
                        .frame(width: geometry.size.width * progress, height: 5)
                }
                .frame(maxHeight: .infinity, alignment: .center)
            }
            .frame(height: 5)
            
            Text("\(count)")
                .font(.body)
                .bold()
                .frame(width: 35, alignment: .trailing)
        }
    }
}
