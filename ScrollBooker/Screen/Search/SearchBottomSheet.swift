//
//  SearchBottomSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

import SwiftUI

struct SearchBottomSheet: View {
    let maxHeight: CGFloat
    let isLoading: Bool
    let isPaging: Bool
    let businesses: [BusinessSheet]
    let totalCount: Int

    var onNavigateToBusinessProfile: (String) -> Void
    var onSelectProduct: (String) -> Void
    var onLoadMore: (BusinessSheet) -> Void
    var onHeaderHeightChange: (CGFloat) -> Void

    @State private var pulseSkeleton = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Capsule()
                    .fill(Color.primary.opacity(0.2))
                    .frame(width: 40, height: 5)
                    .padding(.top, 12)
                
                if isLoading {
                    SkeletonBar(width: 160, height: 10)
                        .padding(.bottom, 16)
                } else {
                    Text("\(totalCount) de rezultate găsite")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 16)
                }
            }
            .frame(maxWidth: .infinity)
            .onGeometryChange(for: CGFloat.self) {
                $0.size.height
            } action: { newHeight in
                onHeaderHeightChange(newHeight)
            }

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 18) {
                    if isLoading {
                        ForEach(1...3, id: \.self) { _ in
                            SearchCardSkeletonView(isAnimating: pulseSkeleton)
                        }
                    } else {
                        ForEach(businesses, id: \.id) { business in
                            SearchCardView(
                                business: business,
                                onNavigateToBusinessProfile: onNavigateToBusinessProfile,
                                onSelectProduct: { productId in }
                            )
                            .onAppear {
                                onLoadMore(business)
                            }
                        }

                        if isPaging {
                            LoadingView()
                                .padding(.vertical, 12)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: maxHeight)
        .background(Color.backgroundSB)
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28))
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: -4)
        .onChange(of: isLoading, initial: true) { _, newValue in
            guard newValue else { return }
            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                pulseSkeleton = true
            }
        }
    }
}
