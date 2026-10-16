//
//  ListItemView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct ListItemView: View {
    var title: String
    var description: String? = nil
    var leadingIcon: String? = nil
    var onClick: () -> Void
    
    var padding: CGFloat = 0
    var showTrailingIcon: Bool = true
    var showRipple: Bool = true
    var color: Color = .onBackgroundSB
    
    var body: some View {
        Button {
            onClick()
        } label: {
            HStack(alignment: .center) {
                if let leadingIcon = leadingIcon, !leadingIcon.isEmpty {
                    Image(systemName: leadingIcon)
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(color)
                    
                    if let description = description, !description.isEmpty {
                        Text(description)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                if showTrailingIcon {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.gray)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, .base)
            .padding(.horizontal, padding)
            .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(.plain)
    }
}

