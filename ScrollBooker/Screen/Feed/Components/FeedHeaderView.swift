//
//  FeedHeaderView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.09.2025.
//

import SwiftUI

struct FeedHeaderView: View {
    let selectedTab: FeedTab
    var onChangeTab: (FeedTab) -> Void
    var onNavigateToFeedSearch: () -> Void
    var onOpenDrawer: () -> Void
    var activeFiltersCount: Int = 0

    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Button {
                    onOpenDrawer()
                } label: {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "line.horizontal.3")
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.6), radius: 4, x: 2, y: 2)

                        if activeFiltersCount > 0 {
                            Text("\(activeFiltersCount)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                                .frame(minWidth: 16, minHeight: 16)
                                .background(Circle().fill(Color.primarySB))
                                .offset(x: 8, y: -8)
                        }
                    }
                }
                
                HStack(spacing: 8) {
                    FeedTabButton(
                        title: "Explore",
                        tab: .explore,
                        selectedTab: selectedTab,
                        onClick: onChangeTab
                    )
                    FeedTabButton(
                        title: "Following",
                        tab: .following,
                        selectedTab: selectedTab,
                        onClick: onChangeTab
                    )
                }         }
            
            Spacer()
            
            Button {
                onNavigateToFeedSearch()
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.6), radius: 4, x: 2, y: 2)
            }
        }
        .padding(.horizontal)
    }
}
