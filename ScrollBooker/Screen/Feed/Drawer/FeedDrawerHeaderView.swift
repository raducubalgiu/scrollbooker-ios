//
//  FeedDrawerHeaderView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import SwiftUI

struct FeedDrawerHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.xs.rawValue) {
            Text("ScrollBooker")
                .font(.title.bold())
                .foregroundColor(Color(white: 0.88))

            Text(String(localized: "chooseWhatDoYouWantToSeeInFeed"))
                .font(.subheadline)
                .foregroundColor(Color(white: 0.67))
        }
        .padding(.top, .xl)
        .padding(.bottom, .base)
    }
}
