//
//  FeedHeaderView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.09.2025.
//

import SwiftUI

struct FeedHeaderView: View {
    @Binding var selectedTab: FeedTab
    var onNavigateToFeedSearch: () -> Void
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Button {
                } label: {
                    Image(systemName: "line.horizontal.3")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.6), radius: 4, x: 2, y: 2)
                }
                
                HStack(spacing: 8) {
                    FeedTabButton(title: "Explore", tab: .explore, selectedTab: $selectedTab)
                    FeedTabButton(title: "Following", tab: .following, selectedTab: $selectedTab)
                }
                .padding(4)
                .background(Color.white.opacity(0.05))
                .clipShape(Capsule())
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    onNavigateToFeedSearch()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.6), radius: 4, x: 2, y: 2)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(90))
                        .shadow(color: .black.opacity(0.6), radius: 4, x: 2, y: 2)
                }
            }
        }
        .padding()
    }
}
