//
//  ProfileHeaderView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.08.2025.
//

import SwiftUI

struct ProfileHeaderView: View {
    var username: String
    
    var body: some View {
        HStack {
            Image(systemName: "line.3.horizontal")
                .foregroundColor(.mainBackground)
            
            Spacer()
            
            Text(username)
                .font(.headline.bold())
            
            Spacer()
            
            Image(systemName: "line.3.horizontal")

        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}

#Preview("Light") {
    ProfileHeaderView(username: "@radu_balgiu")
}

#Preview("Dark") {
    ProfileHeaderView(username: "@radu_balgiu")
        .preferredColorScheme(.dark)
}
