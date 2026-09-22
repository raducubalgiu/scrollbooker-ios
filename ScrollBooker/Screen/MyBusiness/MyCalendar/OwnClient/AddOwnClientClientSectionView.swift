//
//  AddOwnClientClientSectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct AddOwnClientClientSectionView: View {
    let selectedClient: BusinessClient?
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSize.base.rawValue) {
                ZStack {
                    Circle()
                        .fill(Color.primarySB.opacity(0.15))
                        .frame(width: 44, height: 44)

                    Image(systemName: "person.fill")
                        .foregroundColor(.primarySB)
                }

                VStack(alignment: .leading, spacing: 2) {
                    if let selectedClient {
                        Text(selectedClient.fullname)
                            .font(.subheadline.bold())
                            .foregroundColor(.onBackgroundSB)

                        if let phone = selectedClient.phone, !phone.isEmpty {
                            Text(phone)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    } else {
                        Text(String(localized: "selectClient"))
                            .font(.subheadline.bold())
                            .foregroundColor(.onBackgroundSB)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.base)
            .background(Color.surfaceSB)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}
