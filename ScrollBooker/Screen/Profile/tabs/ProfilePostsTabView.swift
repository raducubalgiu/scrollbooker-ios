//
//  ProfilePostsTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct VideoThum: Identifiable, Hashable {
    let id: UUID = .init()
    let url: URL?
}

let posts: [VideoThum] = [
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
    VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg"))
]

struct ProfilePostsTabView: View {
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 1) {
            ForEach(posts) { post in
//                PostGridView(
//                    postId: post.id,
//                    mediaFiles: [post.url],
//                    viewsCount: 100,
//                    onNavigateToPost: { _ in }
//                )
            }
        }
    }
}
