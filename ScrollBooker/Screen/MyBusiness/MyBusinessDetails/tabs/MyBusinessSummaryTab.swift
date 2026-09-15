//
//  MyBusinessSummary.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import SwiftUI

struct MyBusinessSummaryTab: View {
    let businessDetails: BusinessDetails

    private var owner: BusinessOwner { businessDetails.owner }
    private var location: BusinessLocation { businessDetails.location }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSize.xl.rawValue) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: AppSize.m.rawValue) {
                        AvatarView(imageURL: owner.avatarURL, size: .m)

                        VStack(alignment: .leading, spacing: AppSize.xxs.rawValue) {
                            Text(owner.fullName)
                                .font(.headline)
                                .fontWeight(.semibold)

                            Text(owner.profession)
                                .font(.footnote)
                                .foregroundColor(.gray)

                            HStack(spacing: AppSize.xs.rawValue) {
                                Text(owner.ratingsAverage.formatRating())
                                    .fontWeight(.semibold)

                                StarRatingView(rating: Double(owner.ratingsAverage), imageScale: .small)

                                Text("(\(owner.ratingsCount))")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.base)

                    Divider()
                        .padding(.horizontal, .base)

                    HStack(spacing: AppSize.m.rawValue) {
                        Image(systemName: businessDetails.hasEmployees ? "person.2" : "person")
                            .foregroundColor(.primarySB)
                            .frame(width: 48, height: 48)
                            .background(Color.surfaceSB)
                            .cornerRadius(AppSize.base.rawValue)

                        VStack(alignment: .leading, spacing: AppSize.xxs.rawValue) {
                            Text(String(localized: "employees"))
                                .font(.headline)
                                .fontWeight(.bold)

                            Text(String(
                                localized: businessDetails.hasEmployees
                                    ? "businessHasEmployeesLabel"
                                    : "businessNoEmployeesLabel"
                            ))
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                        }
                    }
                    .padding(.base)
                }
                .background(Color.surfaceSB.opacity(0.5))
                .cornerRadius(AppSize.base.rawValue)

                VStack(alignment: .leading, spacing: AppSize.s.rawValue) {
                    Text(String(localized: "address"))
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text(location.formattedAddress ?? location.address)
                        .foregroundColor(.gray)

                    if let mapUrl = location.mapUrl {
                        SectionMap(
                            mapUrl: mapUrl,
                            coordinates: location.coordinates,
                            fullName: owner.fullName,
                            displayDirectionsButton: false
                        )
                        .padding(.top, .base)
                    }
                }
            }
            .padding(.base)
        }
    }
}
