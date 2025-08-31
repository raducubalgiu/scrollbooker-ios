//
//  ProfileUserInfoView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.08.2025.
//

import SwiftUI

struct ProfileUserInfoView: View {
    var url: URL?
    var fullName: String
    var profession: String
    var isBusinessOrEmployee: Bool
    var ratingsAverage: Decimal
    var openingHours: OpeningHours
    var onShowOpeningHoursSheet: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            AvatarView(
                imageURL: URL(string: "https://media.scrollbooker.ro/avatar-male-9.jpeg"),
                size: .xl,
                isOpen: isBusinessOrEmployee ? openingHours.openNow : nil,
            )
            
            VStack(alignment: .leading, spacing: 7) {
                Text(fullName)
                    .font(.headline.bold())
                HStack {
                    Text(profession)
                    Image(systemName: "star.fill")
                        .foregroundColor(.primarySB)
                    Text("\(ratingsAverage)")
                        .font(.headline.bold())
                }
                
                Button {
                    onShowOpeningHoursSheet()
                } label: {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.onBackgroundSB)
                        
                        Text(openingHours.formattedStatus)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.onBackgroundSB)
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(.onBackgroundSB)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview("Light") {
    ProfileUserInfoView(
        url: dummyUserProfile.avatarURL,
        fullName: dummyUserProfile.fullName,
        profession: dummyUserProfile.profession,
        isBusinessOrEmployee: dummyUserProfile.isBusinessOrEmployee,
        ratingsAverage: dummyUserProfile.counters.ratingsAverage,
        openingHours: dummyUserProfile.openingHours,
        onShowOpeningHoursSheet: {}
    )
}

#Preview("Dark") {
    ProfileUserInfoView(
        url: dummyUserProfile.avatarURL,
        fullName: dummyUserProfile.fullName,
        profession: dummyUserProfile.profession,
        isBusinessOrEmployee: dummyUserProfile.isBusinessOrEmployee,
        ratingsAverage: dummyUserProfile.counters.ratingsAverage,
        openingHours: dummyUserProfile.openingHours,
        onShowOpeningHoursSheet: {}
    )
        .preferredColorScheme(.dark)
}

