//
//  BusinessTeamTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessTeamTabView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("team")
                .font(.title2.weight(.heavy))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(0...20, id: \.self) { index in
                        VStack(spacing: 12) {
                            AvatarView(size: .l)
                            Text("Radu Balgiu")
                                .font(.headline.bold())
                            MainButtonOutlined(
                                title: String(localized: "profile"),
                                onClick: {}
                            )
                            .padding(.top, .s)
                        }
                    }
                    .padding(.leading)
                }
            }
        }
        .padding(.top, 8)
        .background(Color(.systemBackground))
    }
}

#Preview("Light") {
    BusinessTeamTabView()
}

#Preview("Dark") {
    BusinessTeamTabView()
        .preferredColorScheme(.dark)
}
