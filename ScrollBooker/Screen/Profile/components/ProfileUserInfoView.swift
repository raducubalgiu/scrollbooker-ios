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
            Circle()
                .frame(width: 90, height: 90)
            
            VStack(alignment: .leading, spacing: 7) {
                Text("Radu Balgiu")
                    .font(.headline.bold())
                HStack {
                    Text("Programmer")
                    Image(systemName: "star.fill")
                        .foregroundColor(.primarySB)
                    Text("4.5")
                }
                
                HStack {
                    Image(systemName: "clock")
                    Text("Deschide luni la 09:00")
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

