//
//  FeedDrawerNearbyToggleView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.10.2026.
//

import SwiftUI

struct FeedDrawerNearbyToggleView: View {
    @Binding var checked: Bool
    let hasLocationAccess: Bool
    let onRequestLocationAccess: () -> Void

    var body: some View {
        HStack(spacing: AppSize.s.rawValue) {
            Image(systemName: checked ? "location.fill" : "location")
                .font(.system(size: 20))
                .foregroundColor(checked ? .primarySB : Color(white: 0.67))

            VStack(alignment: .leading, spacing: AppSize.xxs.rawValue) {
                Text(String(localized: "onlyNearbyPosts"))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(white: 0.88))

                Text(String(localized: hasLocationAccess ? "showPostsFromMyArea" : "locationPermissionNotGranted"))
                    .font(.footnote)
                    .foregroundColor(Color(white: 0.67))
            }

            Spacer()

            Toggle("", isOn: $checked)
                .labelsHidden()
                .tint(.primarySB)
                .disabled(!hasLocationAccess)
        }
        .padding(.base)
        .opacity(hasLocationAccess ? 1 : 0.5)
        .background(checked ? Color.primarySB.opacity(0.12) : Color(white: 0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .contentShape(Rectangle())
        .onTapGesture {
            if hasLocationAccess {
                checked.toggle()
            } else {
                onRequestLocationAccess()
            }
        }
    }
}
