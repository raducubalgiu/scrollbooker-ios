//
//  MyProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct MyProfileScreen: View {
    var body: some View {
        VStack {
            ProfileHeaderView(username: "@radu_balgiu")
            
            ProfileCountersView()
                .padding(.vertical, .xxl)
            
            ProfileUserInfoView()
            
            HStack {
                Button { } label: { Text("Editeaza profilul") }
                .frame(maxWidth: .infinity, minHeight: 60)
                .fontWeight(.semibold)
                .foregroundColor(Color.onSurfaceSB)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.surfaceSB)
                )
                
                Button { } label: {
                    HStack {
                        Image(systemName: "calendar")
                        Text("Urmareste")
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 60)
                .fontWeight(.semibold)
                .foregroundColor(Color.onSurfaceSB)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.surfaceSB)
                )
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview("Light") {
    MyProfileScreen()
}

#Preview("Dark") {
    MyProfileScreen()
        .preferredColorScheme(.dark)
}
