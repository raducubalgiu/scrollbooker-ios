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
            
            HStack(spacing: 0) {
                Image("Brand/drawer_vector_white")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 70)
                
                Spacer(minLength: 0)
            }
            
            Text(String(localized: "chooseWhatDoYouWantToSeeInFeed"))
                .font(.subheadline)
                .foregroundColor(Color(white: 0.67))
                .padding(.leading, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, .xl)
        .padding(.bottom, .base)
    }
}

