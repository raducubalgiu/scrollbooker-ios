//
//  EmploymentRequestCard.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

struct EmploymentRequestCardView: View {
    let employmentRequest: EmploymentRequest
    let onClick: (Int) -> Void
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy HH:mm"
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter.string(from: employmentRequest.createdAt)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                AvatarView(
                    imageURL: employmentRequest.employee.avatarURL,
                    size: .l
                )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(employmentRequest.employee.fullName)
                        .font(.subheadline.bold())
                        .foregroundColor(.onSurfaceSB)
                    
                    Text("@\(employmentRequest.employee.username)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: { onClick(employmentRequest.id) }) {
                    Image(systemName: "trash")
                        .font(.system(size: 20))
                        .foregroundColor(.errorSB.opacity(0.85))
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
            }
            
            Divider().padding(.vertical, .base)
            
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(localized: "proposedProfession"))
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(employmentRequest.profession.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.onSurfaceSB)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(String(localized: "date"))
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(formattedDate)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.onSurfaceSB.opacity(0.8))
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
