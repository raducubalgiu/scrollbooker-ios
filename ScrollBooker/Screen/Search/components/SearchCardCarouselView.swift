//
//  SearchCardCarouselView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import SwiftUI

struct SearchCardCarouselView: View {
    let mediaFiles: [BusinessMediaFile]
    var imageHeight: CGFloat = 230
    var radius: CGFloat = 12

    @State private var currentPage = 0

    var body: some View {
        GeometryReader { geometry in
            let cardWidth = geometry.size.width

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(Array(mediaFiles.enumerated()), id: \.element.id) { index, media in
                        AsyncImage(url: URL(string: media.thumbnailUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color(.systemGray6)
                        }
                        .frame(width: cardWidth, height: imageHeight)
                        .clipped()
                        .id(media.thumbnailKey)
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .onScrollGeometryChange(for: Int.self) { geo in
                let offsetX = geo.contentOffset.x
                return cardWidth > 0 ? Int(round(offsetX / cardWidth)) : 0
            } action: { _, newPage in
                if currentPage != newPage {
                    currentPage = newPage
                }
            }
            .overlay(alignment: .bottom) {
                if mediaFiles.count > 1 {
                    HStack(spacing: 6) {
                        ForEach(0..<mediaFiles.count, id: \.self) { index in
                            let isSelected = currentPage == index

                            Circle()
                                .fill(Color.white.opacity(isSelected ? 0.9 : 0.4))
                                .frame(width: isSelected ? 6.5 : 5.5, height: isSelected ? 6.5 : 5.5)
                                .animation(.spring(response: 0.25, dampingFraction: 0.75), value: currentPage)
                        }
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 9)
                    .background(.black.opacity(0.3))
                    .cornerRadius(10)
                    .padding(.bottom, 12)
                }
            }
            .overlay {
                LinearGradient(
                    colors: [Color.black.opacity(0.1), Color.clear, Color.black.opacity(0.25)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .allowsHitTesting(false)
            }
        }
        .frame(height: imageHeight)
        .clipShape(RoundedRectangle(cornerRadius: radius))
    }
}
