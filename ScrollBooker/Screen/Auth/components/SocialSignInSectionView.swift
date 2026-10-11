//
//  SocialSignInSectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

import SwiftUI

struct SocialSignInSectionView: View {
    var isDisabled: Bool = false
    var onGoogleClick: () -> Void

    var body: some View {
        VStack(spacing: AppSize.m.rawValue) {
            HStack {
                VStack { Divider() }

                Text(String(localized: "auth_or"))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, .xs)

                VStack { Divider() }
            }
            .padding(.vertical, .xs)

            HStack(spacing: AppSize.m.rawValue) {
                Button(action: onGoogleClick) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                            .frame(height: 54)

                        Image("logo_google")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.5 : 1.0)

                Button {
                    print("Apple login tapped")
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                            .frame(height: 54)

                        Image(systemName: "apple.logo")
                            .font(.system(size: 24))
                            .foregroundColor(.primary)
                    }
                }
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.5 : 1.0)
            }
        }
    }
}
