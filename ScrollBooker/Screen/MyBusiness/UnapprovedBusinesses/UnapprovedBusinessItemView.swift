//
//  UnapprovedBusinessItemView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import SwiftUI

struct UnapprovedBusinessItemView: View {
    let item: UnapprovedBusiness
    var isApproving: Bool = false
    var onReject: () -> Void = {}
    var onApprove: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: AppSize.s.rawValue) {
                AvatarView(imageURL: item.avatarURL, size: .m)

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.fullName)
                        .font(.headline.bold())
                        .foregroundColor(.onSurfaceSB)

                    Text("@\(item.username)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            Divider()
                .padding(.vertical, .base)

            Text("\(String(localized: "my_business_unapproved_type")): \(item.business.businessType.name)")
                .font(.subheadline.weight(.medium))
                .foregroundColor(.onSurfaceSB)

            Text("\(String(localized: "my_business_unapproved_address")): \(item.business.location.address)")
                .font(.subheadline)
                .foregroundColor(.onSurfaceSB)
                .padding(.top, .xxs)

            Text(item.business.hasEmployees ? String(localized: "my_business_unapproved_has_employees") : String(localized: "my_business_unapproved_no_employees"))
                .font(.caption.bold())
                .foregroundColor(.primarySB)
                .padding(.horizontal, .s)
                .padding(.vertical, .xxs)
                .background(Color.primarySB.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.top, .s)

            HStack(spacing: AppSize.m.rawValue) {
                MainButtonOutlined(
                    title: String(localized: "my_business_unapproved_reject"),
                    fullWidth: true,
                    onClick: onReject
                )
                .frame(maxWidth: .infinity)

                MainButton(
                    title: String(localized: "my_business_unapproved_approve"),
                    isLoading: isApproving,
                    onClick: onApprove
                )
                .frame(maxWidth: .infinity)
            }
            .padding(.top, .xl)
        }
        .padding(.base)
        .background(Color.surfaceSB)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
