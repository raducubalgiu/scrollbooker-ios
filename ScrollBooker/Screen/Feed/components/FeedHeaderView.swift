//
//  FeedHeaderView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.09.2025.
//

import SwiftUI

struct FeedHeaderView: View {
    var onNavigateToFeedSearch: () -> Void
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "line.horizontal.3")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button {
                onNavigateToFeedSearch()
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .padding()
    }
}

#Preview("Light") {
    FeedHeaderView(onNavigateToFeedSearch: {})
}

#Preview("Dark") {
    FeedHeaderView(onNavigateToFeedSearch: {})
        .preferredColorScheme(.dark)
}
