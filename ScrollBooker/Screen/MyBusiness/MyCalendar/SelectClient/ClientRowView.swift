//
//  ClientRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.09.2026.
//

import SwiftUI

struct ClientRowView: View {
    let client: BusinessClient
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSize.base.rawValue) {
                ZStack {
                    Circle()
                        .fill(Color.primarySB.opacity(0.15))
                        .frame(width: 40, height: 40)

                    Image(systemName: "person.fill")
                        .foregroundColor(.primarySB)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(client.fullname)
                        .font(.subheadline.bold())
                        .foregroundColor(.onBackgroundSB)

                    if let phone = client.phone, !phone.isEmpty {
                        Text(phone)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    } else {
                        Text(String(localized: "noPhoneNumber"))
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

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
            }
            .padding(.vertical, .s)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
