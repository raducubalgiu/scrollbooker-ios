//
//  PostUserView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import SwiftUI

struct PostUserView: View {
    var user: PostUser
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(user.fullName)
                .font(.system(size: 16))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(user.profession)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primarySB)
            }
        }
}
