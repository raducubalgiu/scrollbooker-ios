//
//  FeedSearch.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct FeedSearchScreen: View {
    var onNavigateToSearchResults: () -> Void
    
    var body: some View {
        ScrollView {
            
        }
        
        MainButton(
            title: "Go to Search Results",
            onClick: onNavigateToSearchResults
        )
    }
}

#Preview("Light") {
    FeedSearchScreen(
        onNavigateToSearchResults: {}
    )
}

#Preview("Dark") {
    FeedSearchScreen(
        onNavigateToSearchResults: {}
    )
    .preferredColorScheme(.dark)
}
