//
//  ProfileUserInfoView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.08.2025.
//

import SwiftUI

struct ProfileUserInfoView: View {
    var body: some View {
        HStack(spacing: 15) {
            AvatarView(
                imageURL: URL(string: "https://media.scrollbooker.ro/avatar-male-9.jpeg"),
                size: .xl,
                presence: .open,
            )
            
            VStack(alignment: .leading, spacing: 7) {
                Text("Radu Balgiu")
                    .font(.headline.bold())
                HStack {
                    Text("Stylist")
                    Image(systemName: "star.fill")
                        .foregroundColor(.primarySB)
                    Text("4.5")
                        .font(.headline.bold())
                }
                
                HStack {
                    Image(systemName: "clock")
                    Text("Deschide luni la 09:00")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("Light") {
    ProfileUserInfoView()
}

#Preview("Dark") {
    ProfileUserInfoView()
        .preferredColorScheme(.dark)
}

