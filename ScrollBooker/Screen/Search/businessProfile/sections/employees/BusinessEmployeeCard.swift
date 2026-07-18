//
//  BusinessEmployeeCard.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.07.2026.
//

import SwiftUI

struct BusinessEmployeeCard: View {
    let employee: BusinessProfileEmployee
    
    var body: some View {
        VStack {
            AvatarWithRatingView(
                rating: Double(employee.ratingsAverage),
                size: .xl,
                onClick: {}
            )
            .padding(.bottom, .m)
            
            Text(employee.fullName)
                .font(.subheadline.bold())
                .lineLimit(1)
            
            Text(employee.profession)
                .font(.footnote)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .frame(width: 90)
    }
    
}
