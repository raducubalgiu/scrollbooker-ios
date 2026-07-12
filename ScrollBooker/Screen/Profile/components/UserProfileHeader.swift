//
//  UserProfileHeader.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct UserProfileHeaderView: View {
    var username: String
    var onBack: () -> Void
    
    var body: some View {
        HStack {
            Button {
                onBack()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.onBackgroundSB)
                    .font(.system(size: 24))
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Text(username)
                .font(.headline.bold())
            
            Spacer()
            
            Image(systemName: "line.3.horizontal")
                .foregroundColor(.backgroundSB)
                .font(.system(size: 24))

        }
        .frame(maxWidth: .infinity)
    }
}
