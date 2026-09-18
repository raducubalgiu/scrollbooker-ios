//
//  PostGridView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

struct PostGridView: View {
    let postId: Int
    let mediaFiles: [PostMediaFile]
    let viewsCount: Int
    var rating: Int? = nil
    let onNavigateToPost: (Int) -> Void

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { geometry in
                AsyncImage(url: URL(string: mediaFiles.first?.thumbnailUrl ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    case .failure, .empty:
                        Color(.systemGray5)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            .aspectRatio(9.0 / 12.0, contentMode: .fill)
            
            LinearGradient(
                colors: [
                    Color.black.opacity(0.15),
                    Color.clear,
                    Color.black.opacity(0.5)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .allowsHitTesting(false)

            HStack(spacing: 3) {
                Image(systemName: "play")
                    .font(.system(size: 12, weight: .bold))
                
                Text("\(viewsCount)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)

            if let rating {
                PostGridRatingBadge(rating: rating)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(8)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onNavigateToPost(postId)
        }
    }
}

private struct PostGridRatingBadge: View {
    let rating: Int

    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "star.fill")
                .font(.system(size: 11))
                .foregroundColor(.ratingSB)

            Text("\(rating)")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(Color.black.opacity(0.45))
        .clipShape(Capsule())
    }
}
