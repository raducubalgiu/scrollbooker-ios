//
//  MainButton.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct MainButton: View {
    var title: String
    var size: AppButtonSize = .large
    var isDisabled: Bool = false
    var isLoading: Bool = false
    var bgColor: Color = .primarySB
    var color: Color = .onPrimarySB
    var onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            Group {
                if isLoading {
                    ProgressView()
                        .scaleEffect(size == .small ? 0.8 : 1.0)
                } else {
                    Text(title)
                        .font(size.font)
                }
            }
            .frame(maxWidth: .infinity, minHeight: size.minHeight)
            .contentShape(Rectangle())
        }
        .fontWeight(.semibold)
        .padding(.horizontal, size.horizontalPadding)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill((isDisabled || isLoading) ? Color.surfaceSB : bgColor)
        )
        .foregroundColor(isDisabled ? .gray : color)
        .disabled(isDisabled || isLoading)
        .buttonStyle(.plain)
    }
}

