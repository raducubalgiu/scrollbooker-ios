//
//  BusinessInfoView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 25) {
                AvatarView(imageURL: URL(string: "https://media.scrollbooker.ro/avatar-male-9.jpeg"), size: .xl)
                
                VStack(spacing: 15) {
                    HStack(spacing: 10) {
                        ProfileCounterView(
                            counter: 155,
                            label: String(localized: "followers"),
                            onClick: {}
                        )
                        
                        VerticalDivider(height: 20)
                            .padding(.horizontal)
                        
                        ProfileCounterView(
                            counter: 1510,
                            label: String(localized: "following"),
                            onClick: {}
                        )
                    }
                    Button(action: {}) {
                        Text("follow")
                            .fontWeight(.semibold)
                            .foregroundColor(.onBackgroundSB)
                            .padding(.vertical, 12.5)
                            .frame(maxWidth: .infinity)
                    }
                    .overlay(
                        Capsule()
                            .stroke(.divider, lineWidth: 1)
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(alignment: .leading, spacing: 7) {
                Text("House Of Barbers")
                    .font(.title2.weight(.bold))
                Text("Strada Randunelelor, nr 45, Sector 2")
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 8) {
                    Image(systemName: "location");
                    Text("la 5 km de tine")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                HStack(spacing: 8) {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(.green)
                    Text("Deschis acum")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        
        Spacer()
    }
}

#Preview("Light") {
    BusinessInfoView()
}

#Preview("Dark") {
    BusinessInfoView()
        .preferredColorScheme(.dark)
}
