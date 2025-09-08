//
//  ProfileHeaderView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.08.2025.
//

import SwiftUI

struct MyProfileHeaderView: View {
    var username: String
    var onOpenMenuSheet: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "line.3.horizontal")
                .foregroundColor(.backgroundSB)
            
            Spacer()
            
            Text(username)
                .font(.headline.bold())
            
            Spacer()
            
            Button {
                onOpenMenuSheet()
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
    MyProfileHeaderView(
        username: "@radu_balgiu",
        onOpenMenuSheet: {}
    )
    
    Spacer()
}

#Preview("Dark") {
    MyProfileHeaderView(
        username: "@radu_balgiu",
        onOpenMenuSheet: {}
    )
        .preferredColorScheme(.dark)
    
    Spacer()
}
