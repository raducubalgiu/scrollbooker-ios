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
                ProfilePostCell(post: post)
            }
        }
    }
}

struct ProfilePostCell: View {
    let post: VideoThum
    
    var body: some View {
        Button(action: {}) {
            ZStack(alignment: .bottomLeading) {
                ZStack(alignment: .topLeading) {
                    AsyncImage(url: post.url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color(uiColor: .secondarySystemBackground)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.2),
                        Color.clear,
                        Color.black.opacity(0.45)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .allowsHitTesting(false)
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 11, weight: .bold))
                        Text("10000")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 6)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .aspectRatio(3.0 / 4.0, contentMode: .fit)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

