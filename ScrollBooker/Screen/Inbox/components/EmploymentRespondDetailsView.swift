//
//  EmploymentRespondDetailsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

import SwiftUI

struct EmploymentRespondDetailsView: View {
    let employer: EmploymentRequestUser

    private var paragraphs: [String] {
        [
            String(localized: "youWillReceiveAccessToYourOwnCalendarAndAppointments"),
            "\(String(localized: "youWillBeAbleToEditAndAddServicesWithinYourBusiness")) \(employer.fullName)",
            String(localized: "clientsWillBeAbleToSelectYouDirectlyBasedYourAvailability"),
            String(localized: "youWillAppearInThePublicBusinessProfile"),
            String(localized: "youWillReceiveReviewsFromYourClients"),
            String(localized: "youCouldResignAnytime")
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: AppSize.m.rawValue) {
                ZStack(alignment: .bottomTrailing) {
                    AvatarView(imageURL: employer.avatarURL, size: .xxl)

                    Circle()
                        .fill(Color.primarySB)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Image(systemName: "briefcase.fill")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .overlay(
                            Circle().stroke(Color.backgroundSB, lineWidth: 2)
                        )
                }

                Text("\(employer.fullName) \(String(localized: "sentYouAnEmploymentRequest"))")
                    .font(.body)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)

            Text(String(localized: "hereIsWhatYouShouldNow"))
                .font(.headline.bold())
                .padding(.top, .xl)
                .padding(.bottom, .xxs)

            Text("\(String(localized: "byAcceptingThisRequest")):")
                .foregroundColor(.gray)
                .padding(.bottom, .m)

            VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                ForEach(paragraphs, id: \.self) { text in
                    BulletListItem(text: text, color: .gray)
                }
            }
        }
        .padding(.horizontal, .xl)
        .padding(.top, .xl)
        .padding(.bottom, .base)
    }
}
