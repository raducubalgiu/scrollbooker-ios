//
//  PublicPhoneSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import SwiftUI

struct PublicPhoneSuccessView: View {
    let info: PublicPhoneInfo
    let isEmployee: Bool
    let isSwitching: Bool
    let switchError: String?
    var onUseBusinessNumber: () -> Void
    var onEditPersonalNumber: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
            Text(String(localized: "publicPhoneDescription"))
                .font(.footnote)
                .foregroundColor(.gray)

            if isEmployee {
                PublicPhoneOptionRowView(
                    title: String(localized: "publicPhoneUseBusinessNumber"),
                    value: Self.maskedOrNotSet(info.businessPublicPhone),
                    isSelected: info.usesBusinessNumber,
                    isLoading: isSwitching,
                    onClick: onUseBusinessNumber
                )

                Divider()

                PublicPhoneOptionRowView(
                    title: String(localized: "publicPhoneUseOwnNumber"),
                    value: Self.maskedOrNotSet(info.publicPhone),
                    isSelected: !info.usesBusinessNumber,
                    isLoading: false,
                    onClick: onEditPersonalNumber
                )

                if let switchError {
                    Text(switchError)
                        .font(.footnote)
                        .foregroundColor(.errorSB)
                }
            } else {
                AccountInfoRowView(
                    title: String(localized: "phoneNumber"),
                    value: Self.maskedOrNotSet(info.publicPhone),
                    showChevron: true,
                    onClick: onEditPersonalNumber
                )
            }

            Spacer()
        }
        .padding(.horizontal, .base)
        .padding(.top, .base)
    }

    private static func maskedOrNotSet(_ phone: String?) -> String {
        guard let phone, phone.count > 6 else {
            return String(localized: "accountInfoNotSet")
        }
        let prefix = phone.prefix(3)
        let suffix = phone.suffix(3)
        let maskLength = max(phone.count - 6, 3)
        return "\(prefix)\(String(repeating: "*", count: maskLength))\(suffix)"
    }
}

private struct PublicPhoneOptionRowView: View {
    let title: String
    let value: String
    let isSelected: Bool
    let isLoading: Bool
    var onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            HStack {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color.primarySB)
                            .frame(width: 22, height: 22)

                        Circle()
                            .fill(Color.backgroundSB)
                            .frame(width: 9, height: 9)
                    } else {
                        Circle()
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            .frame(width: 22, height: 22)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.bold())
                        .foregroundColor(.onBackgroundSB)

                    Text(value)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                Spacer()

                if isLoading {
                    ProgressView()
                }
            }
            .padding(.vertical, .m)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
    }
}
