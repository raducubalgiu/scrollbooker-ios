//
//  OnboardingStepsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

import SwiftUI

struct OnboardingStep: Hashable {
    let title: String
    let description: String
}

struct OnboardingStepsView: View {
    let steps: [OnboardingStep]

    var body: some View {
        Grid(alignment: .topLeading, horizontalSpacing: AppSize.m.rawValue, verticalSpacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                let isLast = index == steps.count - 1

                GridRow(alignment: .top) {
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(isLast ? Color.primarySB : Color.surfaceSB)
                                .frame(width: 32, height: 32)

                            if isLast {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            } else {
                                Text("\(index + 1)")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.onBackgroundSB)
                            }
                        }

                        if !isLast {
                            Rectangle()
                                .fill(Color.surfaceSB)
                                .frame(width: 2)
                                .frame(maxHeight: .infinity)
                        }
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(step.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(isLast ? .primarySB : .onBackgroundSB)

                        Text(step.description)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, isLast ? 0 : AppSize.base.rawValue)
                }
            }
        }
    }
}
