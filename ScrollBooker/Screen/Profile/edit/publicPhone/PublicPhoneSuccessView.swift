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
    let isUpdatingContactPreference: Bool
    let contactPreferenceError: String?
    var onUseBusinessNumber: () -> Void
    var onEditPersonalNumber: () -> Void
    var onToggleWhatsapp: (Bool) -> Void
    var onToggleCalls: (Bool) -> Void

    private var isInheritingBusinessNumber: Bool {
        isEmployee && info.usesBusinessNumber
    }

    private var effectiveContactPreference: ContactPreferenceEnum {
        isInheritingBusinessNumber ? info.businessContactPreference : info.contactPreference
    }

    private var isContactPreferenceEditable: Bool {
        !isInheritingBusinessNumber && info.publicPhone != nil
    }

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

            Divider()
                .padding(.top, .s)

            Text(String(localized: "contactPreferenceSectionTitle"))
                .font(.subheadline.bold())
                .foregroundColor(.gray)
                .padding(.top, .s)

            VStack(spacing: 0) {
                Toggle(
                    String(localized: "contactPreferenceWhatsapp"),
                    isOn: Binding(
                        get: { effectiveContactPreference.acceptsWhatsapp },
                        set: { onToggleWhatsapp($0) }
                    )
                )
                .disabled(!isContactPreferenceEditable || isUpdatingContactPreference)
                .padding(.vertical, .s)

                Divider()

                Toggle(
                    String(localized: "contactPreferencePhone"),
                    isOn: Binding(
                        get: { effectiveContactPreference.acceptsCalls },
                        set: { onToggleCalls($0) }
                    )
                )
                .disabled(!isContactPreferenceEditable || isUpdatingContactPreference)
                .padding(.vertical, .s)
            }
            .tint(.primarySB)

            if isInheritingBusinessNumber {
                Text(String(localized: "contactPreferenceInheritedNote"))
                    .font(.footnote)
                    .foregroundColor(.gray)
            } else if !isContactPreferenceEditable {
                Text(String(localized: "contactPreferenceNoPhoneNote"))
                    .font(.footnote)
                    .foregroundColor(.gray)
            }

            if let contactPreferenceError {
                Text(contactPreferenceError)
                    .font(.footnote)
                    .foregroundColor(.errorSB)
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
