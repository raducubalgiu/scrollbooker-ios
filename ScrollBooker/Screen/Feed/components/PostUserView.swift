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
            
            Text(user.usernameOrProfession)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primarySB)
            }
        }
}

#Preview("Dark") {
    PostUserView(user: dummyBookNowPosts[0].user)
        .preferredColorScheme(.dark)
}
