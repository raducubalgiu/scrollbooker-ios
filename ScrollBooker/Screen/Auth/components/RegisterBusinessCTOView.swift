//
//  RegisterBusinessCTOView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

import SwiftUI

struct RegisterBusinessCTOView: View {
    var onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            HStack(spacing: AppSize.m.rawValue) {
                Image(systemName: "scissors")
                    .font(.system(size: 22))
                    .foregroundColor(.primarySB)

                VStack(alignment: .leading, spacing: 2) {
                    Text(String(localized: "auth_register_business_cta_title"))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text(String(localized: "auth_register_business_cta_description"))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote.bold())
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(AppSize.base.rawValue)
            .background(Color.surfaceSB)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}
