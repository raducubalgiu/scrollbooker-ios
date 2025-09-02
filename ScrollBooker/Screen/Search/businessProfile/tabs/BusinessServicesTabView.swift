//
//  BusinessServicesTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessServicesTabView: View {
    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<10, id: \.self) { i in
                HStack {
                    VStack(alignment: .leading) {
                        Text("Tuns Classic \(i+1)").font(.body.weight(.semibold))
                        Text("45 min").font(.subheadline).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("85 RON").font(.body.weight(.bold))
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
    }
}

#Preview("Light") {
    BusinessServicesTabView()
}

#Preview("Dark") {
    BusinessServicesTabView()
        .preferredColorScheme(.dark)
}
