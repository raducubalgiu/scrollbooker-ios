//
//  UserProfileHeader.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct UserProfileHeaderView: View {
    var username: String
    var onBack: () -> Void
    var onShare: () -> Void

    var body: some View {
        HStack {
            Button {
                onBack()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.onBackgroundSB)
                    .font(.system(size: 24))
            }
            .buttonStyle(.plain)

            Spacer()

            Text(username)
                .font(.headline.bold())

            Spacer()

            Button {
                onShare()
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.onBackgroundSB)
                    .font(.system(size: 20))
            }
            .buttonStyle(.plain)

        }
        .frame(maxWidth: .infinity)
    }
}
