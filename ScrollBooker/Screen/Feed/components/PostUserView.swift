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
                .font(.title3.bold())
                .foregroundColor(.white)
            
            HStack {
                Text(user.usernameOrProfession)
                    .foregroundColor(.primarySB)
                
                Image(systemName: "location")
                    .foregroundColor(.white)
                
                Text("5 km")
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview("Dark") {
    PostUserView(user: dummyBookNowPosts[0].user)
        .preferredColorScheme(.dark)
}
