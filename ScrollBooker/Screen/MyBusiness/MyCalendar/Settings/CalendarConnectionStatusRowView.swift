//
//  CalendarConnectionStatusRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.09.2026.
//

import SwiftUI

struct CalendarConnectionStatusRowView: View {
    let connection: CalendarConnection?

    private var isConnected: Bool { connection?.isActive == true }

    var body: some View {
        HStack(spacing: AppSize.m.rawValue) {
            Image(systemName: isConnected ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .foregroundColor(isConnected ? .green : .gray)

            VStack(alignment: .leading, spacing: 2) {
                Text(isConnected ? String(localized: "calendarConnected") : String(localized: "calendarNotConnected"))
                    .font(.subheadline.bold())
                    .foregroundColor(.onBackgroundSB)

                if isConnected, let email = connection?.googleAccountEmail {
                    Text(email)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }

            Spacer()
        }
        .padding(.base)
        .background(Color.surfaceSB)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
