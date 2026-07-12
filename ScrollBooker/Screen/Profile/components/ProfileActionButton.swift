//
//  ProfileActionButton.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import SwiftUI

struct ProfileActionButton: View {
    let title: String
    var startIcon: String? = nil
    
    var isOutlined: Bool = false
    
    var backgroundColor: Color = Color.surfaceSB
    var foregroundColor: Color = Color.onSurfaceSB
    var borderColor: Color = Color.gray.opacity(0.5)

    let onClick: () -> Void

    var body: some View {
        Button {
            onClick()
        } label: {
            HStack(spacing: 8) {
                if let iconName = startIcon {
                    Image(systemName: iconName)
                }
                
                Text(title)
                    .font(.subheadline.bold())
            }
            .foregroundColor(isOutlined ? foregroundColor : foregroundColor)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(
                Group {
                    if isOutlined {
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(borderColor, lineWidth: 1)
                    } else {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(backgroundColor)
                    }
                }
            )
        }
    }
}
