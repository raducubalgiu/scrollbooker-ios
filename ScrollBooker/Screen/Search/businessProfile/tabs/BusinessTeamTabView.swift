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
            ForEach(0..<6, id: \.self) { i in
                HStack(spacing: 12) {
                    Circle().fill(Color.gray.opacity(0.3)).frame(width: 56, height: 56)
                    VStack(alignment: .leading) {
                        Text("Stylist \(i+1)").font(.body.weight(.semibold))
                        Text("Fade • Beard • Kids").foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
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
