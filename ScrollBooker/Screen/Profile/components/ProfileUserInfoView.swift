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
    var ratingsAverage: Float
    var openingHours: OpeningHours
    var distanceKm: Double?
    var address: String?
    var onShowOpeningHoursSheet: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            AvatarView(
                imageURL: url,
                size: .xxl,
                isOpen: isBusinessOrEmployee ? openingHours.openNow : nil,
            )
            
            VStack(alignment: .leading, spacing: 5) {
                Text(fullName)
                    .font(.headline.bold())
                
                HStack(spacing: 6) {
                    Text(profession)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    if(isBusinessOrEmployee) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.ratingSB)
                        
                        Text("\(ratingsAverage.formatRating())")
                            .font(.headline.bold())
                    }
                }
                
                if(isBusinessOrEmployee) {
                    Button {
                        onShowOpeningHoursSheet()
                    } label: {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.onBackgroundSB)
                            
                            Text(openingHours.formattedStatus)
                                .font(.footnote.bold())
                                .foregroundColor(.onBackgroundSB)
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.onBackgroundSB)
                        }
                    }
                    .padding(.top, .xxs)
                }

                if isBusinessOrEmployee, let address {
                    HStack(spacing: 0) {
                        if let distanceKm {
                            Text("\(String(format: "%.1f", distanceKm))km")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .lineLimit(1)

                            Text("  \u{2022}  ")
                                .foregroundColor(.gray)
                        }

                        Text(address)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    .padding(.top, .xxs)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

