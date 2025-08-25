//
//  ProfileHeaderView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.08.2025.
//

import SwiftUI

struct ProfileHeaderView: View {
    var onShowBottomSheet: () -> Void
    var username: String
    
    var body: some View {
        HStack {
            Image(systemName: "line.3.horizontal")
                .foregroundColor(.mainBackground)
            
            Spacer()
            
            Text(username)
                .font(.headline.bold())
            
            Spacer()
            
            Button {
                onShowBottomSheet()
            } label: {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.onBackgroundSB)
                    .font(.system(size: 24))
            }
            .buttonStyle(.plain)

        }
        .frame(maxWidth: .infinity)
    }
}

#Preview("Light") {
    ProfileHeaderView(
        onShowBottomSheet: {},
        username: "@radu_balgiu",
    )
    
    Spacer()
}

#Preview("Dark") {
    ProfileHeaderView(
        onShowBottomSheet: {},
        username: "@radu_balgiu",
    )
        .preferredColorScheme(.dark)
    
    Spacer()
}
