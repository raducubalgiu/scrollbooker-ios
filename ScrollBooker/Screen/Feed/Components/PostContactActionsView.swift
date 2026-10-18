//
//  PostContactActionsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.10.2026.
//

import SwiftUI

struct PostContactActionsView: View {
    var contact: ContactInfo
    var onContact: () -> Void
    var onOpenServices: () -> Void

    private var contactAction: ContactActionInfo {
        ContactActionInfo(contact: contact, onOpenContactSheet: onContact)
    }

    var body: some View {
        HStack(spacing: AppSize.s.rawValue) {
            if contactAction.isVisible {
                Button(action: contactAction.onClick) {
                    HStack(spacing: AppSize.xs.rawValue) {
                        if contactAction.isWhatsAppStyled {
                            Image(systemName: "phone.bubble.left.fill")
                        }
                        Text(contactAction.title)
                            .font(.footnote.bold())
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .fill(contactAction.isWhatsAppStyled ? Color(red: 0.145, green: 0.827, blue: 0.4) : Color.primarySB)
                    )
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }

            Button(action: onOpenServices) {
                Text(String(localized: "prices"))
                    .font(.footnote.bold())
                    .foregroundColor(.black)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.white.opacity(0.9))
                    )
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }
}
