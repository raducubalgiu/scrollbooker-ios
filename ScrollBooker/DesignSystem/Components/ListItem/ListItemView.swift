//
//  ListItemView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct ListItemView: View {
    var title: String
    var leadingIcon: String?
    var onClick: () -> Void
    
    var padding: CGFloat = 0
    var showTrailingIcon: Bool = true
    var showRipple: Bool = true
    
    var body: some View {
        Button {
            onClick()
        } label: {
            HStack {
                HStack {
                    if !(leadingIcon ?? "").isEmpty {
                        Image(systemName: leadingIcon!)
                            .foregroundColor(.onBackgroundSB)
                    }
                    
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.onBackgroundSB)
                }
                
                Spacer()
                
                if (showTrailingIcon) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.gray)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, .m)
            .padding(.horizontal, padding)
            .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(.plain)
    }
}

#Preview("Light") {
    ListItemView(
        title: "Some title",
        leadingIcon: "",
        onClick: {}
    )
}

#Preview("Dark") {
    ListItemView(
        title: "Some Title",
        leadingIcon: "",
        onClick: {}
    )
        .preferredColorScheme(.dark)
}
