//
//  BusinessTeamTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessEmployeesTabView: View {
    let employees: [BusinessProfileEmployee]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(employees) { employee in
                    VStack(spacing: 5) {
                        AvatarWithRatingView(
                            rating: Double(employee.ratingsAverage),
                            onClick: {}
                        )
                        
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
            .padding(.horizontal, 16)
        }
    }
}
