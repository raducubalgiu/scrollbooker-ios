//
//  CollectBusinessValidationScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct CollectBusinessValidationScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 50))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.primarySB)
                    .padding(.bottom, .xl)

                Text(String(localized: "onboarding_business_validation_title"))
                    .font(.largeTitle.bold())
                    .padding(.bottom, .xs)

                Text(String(localized: "onboarding_business_validation_description"))
                    .foregroundColor(.gray)

                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                    Text(String(localized: "onboarding_business_validation_response_time"))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, .base)

                Text(String(localized: "onboarding_business_validation_next_steps_title"))
                    .font(.title.bold())
                    .padding(.bottom, .xs)

                Text(String(localized: "onboarding_business_validation_next_steps_description"))
                    .foregroundColor(.gray)
                    .padding(.bottom, .base)

                BulletListItem(
                    text: String(localized: "onboarding_business_validation_step_1"),
                    color: .gray
                )

                BulletListItem(
                    text: String(localized: "onboarding_business_validation_step_2"),
                    color: .gray
                )

                BulletListItem(
                    text: String(localized: "onboarding_business_validation_step_3"),
                    color: .gray
                )
                .padding(.bottom, .base)

                Text(String(localized: "onboarding_business_validation_footer"))
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)
                    .padding(.bottom, .base)
            }
            .padding(.xl)
        }
    }
}
