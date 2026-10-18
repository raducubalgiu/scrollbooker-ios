//
//  PublicPhoneOptionRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.10.2026.
//

import SwiftUI

struct PublicPhoneOptionRowView: View {
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
