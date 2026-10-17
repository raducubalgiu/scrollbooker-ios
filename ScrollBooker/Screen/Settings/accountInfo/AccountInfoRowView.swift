//
//  AccountInfoRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import SwiftUI

struct AccountInfoRowView: View {
    let title: String
    let value: String
    var showChevron: Bool = true
    var onClick: (() -> Void)? = nil

    var body: some View {
        Group {
            if let onClick {
                Button(action: onClick) { content }
                    .buttonStyle(.plain)
            } else {
                content
            }
        }
    }

    private var content: some View {
        HStack {
            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(.onBackgroundSB)

            Spacer()

            HStack(spacing: 6) {
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .truncationMode(.middle)

                if showChevron {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, .m)
        .contentShape(Rectangle())
    }
}
