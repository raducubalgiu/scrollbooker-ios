//
//  MyCalendarSettingsRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct MyCalendarSettingsRowView: View {
    let title: String
    let description: String
    let value: String
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline.bold())
                        .foregroundColor(.onBackgroundSB)

                    Text(description)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                Spacer()

                HStack(spacing: 4) {
                    Text(value)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, .m)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
