//
//  StatBarRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import SwiftUI

struct StatBarRowView: View {
    let label: String
    let valueString: String
    let progressPercentage: Float

    private var safeProgress: Double {
        Double(progressPercentage.isFinite ? progressPercentage : 0).clamped(to: 0...1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.onBackgroundSB)

                Spacer()

                Text(valueString)
                    .font(.subheadline.bold())
                    .foregroundColor(.onBackgroundSB)
            }

            ProgressView(value: safeProgress)
                .progressViewStyle(.linear)
                .tint(.primarySB)
                .frame(height: 8)
                .clipShape(RoundedCornerShapeSmall())
        }
    }
}

private struct RoundedCornerShapeSmall: Shape {
    func path(in rect: CGRect) -> Path {
        Path(roundedRect: rect, cornerRadius: 2)
    }
}

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
