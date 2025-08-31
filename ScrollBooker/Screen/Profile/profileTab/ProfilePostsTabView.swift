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

struct ProfilePostsTabView: View {
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)
    
    let posts: [VideoThum] = [
        VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
        VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
        VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
        VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg")),
        VideoThum(url: URL(string: "https://media.scrollbooker.ro/thumbnail-url-post-6.jpg"))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(posts) { post in
                    ZStack(alignment: .topLeading) {
                        Text("Last Minute")
                            .font(.system(size: 11, weight: .semibold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.cyan)
                                    .shadow(radius: 1, y: 1)
                            )
                            .padding(.horizontal, 8)
                            .padding(.top, 6)
                            .foregroundColor(.white)
                        
                        VStack {
                            Spacer()
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.45)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 70)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                HStack(spacing: 6) {
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 11, weight: .bold))
                                    Text("10000")
                                        .font(.system(size: 12, weight: .semibold))
                                }
                                    .padding(.horizontal, 8)
                                    .padding(.bottom, 6)
                                    .foregroundColor(.white),
                                alignment: .bottomLeading
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(3.0/4.0, contentMode: .fit)
                    .background(
                        AsyncImage(url: post.url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Color(white: 0.12)
                        }
                    )
                    .clipped()
                    .contentShape(Rectangle())
                }
            }
        }
    }
}

#Preview("Light") {
    ProfilePostsTabView()
}

#Preview("Dark") {
    ProfilePostsTabView()
        .preferredColorScheme(.dark)
}
