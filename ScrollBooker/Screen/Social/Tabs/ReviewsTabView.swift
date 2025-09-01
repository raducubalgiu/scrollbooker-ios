//
//  ReviewsTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 28.08.2025.
//

import SwiftUI

enum ReviewTab: String, CaseIterable, Identifiable {
    case written = "Scrise"
    case video = "Video"

    var id: String { rawValue }
}

struct ReviewsTabView: View {
    @State private var selection: ReviewTab = .written
    @Namespace private var indicatorNS
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)
    
    let posts: [VideoThum] = [
        VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
        VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
        VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
        VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
        VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
        VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    ]
    
    @State var selected: Set<Int> = []
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: .sectionHeaders) {
                Section {
                    ReviewSummaryCardView(
                        summary: ReviewSummary(
                            averageRating: 4.2,
                            totalReviews: 100,
                            breakdown: [
                                RatingBreakdown(rating: 1, count: 10),
                                RatingBreakdown(rating: 2, count: 10),
                                RatingBreakdown(rating: 3, count: 10),
                                RatingBreakdown(rating: 4, count: 10),
                                RatingBreakdown(rating: 5, count: 60)
                            ]
                        ),
                        selectedRatings: $selected
                    )
                    .padding(.top)
                }
                Section {
                    switch selection {
                    case .written:
                        LazyVStack {
                            ForEach(userReviews) { review in
                                ReviewCardView(review: review)
                                    .padding(.horizontal)
                            }
                        }
                    case .video:
                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(posts) { post in
                                PostGridView()
                            }
                        }
                    }
                } header: {
                    HStack {
                        ForEach(ReviewTab.allCases) { tab in
                            Button {
                                selection = tab
                            } label: {
                                Text(tab.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(selection == tab ? .bold : .medium)
                                    .foregroundStyle(selection == tab ? .primary : .secondary)
                                    .padding(.vertical, 8)
                            }
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
                            .padding(.horizontal, .base)
                            .background(
                                RoundedRectangle(cornerRadius: 50)
                                    .fill(selection == tab ? Color.primarySB : Color.surfaceSB)
                            )
                            .foregroundColor(
                                selection == tab ? Color.onPrimarySB : Color.onBackgroundSB
                            )
                            .padding(.vertical)
                            .buttonStyle(.plain)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.backgroundSB)
                }
            }
        }
    }
}

#Preview("Light") {
    ReviewsTabView()
}

#Preview("Dark") {
    ReviewsTabView()
        .preferredColorScheme(.dark)
}
