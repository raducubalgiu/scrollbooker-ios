//
//  EmplpyeeCard.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import SwiftUI

struct EmployeeCardView: View {
    let employee: Employee
    let onNavigateToDismissalScreen: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                AvatarWithRatingView(
                    rating: employee.ratingsAverage,
                    onClick: {},
                )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(employee.fullName)
                        .font(.subheadline.bold())
                        .foregroundColor(.onSurfaceSB)
                    
                    Text(employee.job)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: onNavigateToDismissalScreen) {
                    Image(systemName: "person.badge.minus")
                        .font(.system(size: 20))
                        .foregroundColor(.errorSB.opacity(0.85))
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
            }
            
            Divider().padding(.vertical, .base)
            
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(localized: "hireDate"))
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(employee.hireDate)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.onSurfaceSB)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(String(localized: "managedProducts"))
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("\(employee.productsCount)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.onSurfaceSB)
                }
            }
        }
        .padding(.base)
        .background(Color.surfaceSB)
        .cornerRadius(12)
        .padding(.horizontal, .xl)
        .padding(.bottom, .m)
    }
}
