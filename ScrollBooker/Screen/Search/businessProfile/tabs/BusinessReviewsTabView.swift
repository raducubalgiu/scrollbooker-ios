//
//  BusinessReviewTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessReviewsTabView: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<12, id: \.self) { i in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Circle().fill(Color.gray.opacity(0.3)).frame(width: 32, height: 32)
                        Text("Client \(i+1)").font(.subheadline.weight(.semibold))
                        Spacer()
                        HStack(spacing: 2) { ForEach(0..<5, id: \.self) { _ in Image(systemName: "star.fill") } }
                            .font(.caption2)
                    }
                    Text("Foarte mulțumit. Servicii excelente, recomand!").font(.body)
                }
                .padding(16)
                Divider()
            }
        }
        .background(Color(.systemBackground))
    }
}

#Preview("Light") {
    BusinessReviewsTabView()
}

#Preview("Dark") {
    BusinessReviewsTabView()
        .preferredColorScheme(.dark)
}

