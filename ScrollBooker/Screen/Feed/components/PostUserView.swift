//
//  PostUserView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import SwiftUI

struct PostUserView: View {
    var user: UserMini
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(user.fullName)
                .font(.system(size: 16))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            HStack(spacing: 0) {
                Text(user.usernameOrProfession)
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.primarySB)
                
                Text(" • 5 km")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview("Dark") {
    PostUserView(user: dummyBookNowPosts[0].user)
        .preferredColorScheme(.dark)
}
