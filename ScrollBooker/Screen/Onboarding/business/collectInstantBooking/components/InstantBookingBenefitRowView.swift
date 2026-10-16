//
//  InstantBookingBenefitRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.10.2026.
//

import SwiftUI

struct InstantBookingBenefitRowView: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: AppSize.base.rawValue) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.primarySB)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: AppSize.xxs.rawValue) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)

                Text(description)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
}
