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
        VStack(spacing: 12) {
            Text("team")
                .font(.title2.weight(.heavy))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
                            
                            Text(employee.profession)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.leading)
                }
            }
        }
        .padding(.top, 8)
    }
}
