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
        ZStack(alignment: .bottom) {
            TabView(selection: $currentPage) {
                ForEach(Array(mediaFiles.enumerated()), id: \.element.id) { index, media in
                    AsyncImage(url: URL(string: media.thumbnailUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color(.systemBackground)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: imageHeight)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            
            LinearGradient(
                colors: [Color.black.opacity(0.35), Color.clear],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 40)
            
            HStack(spacing: 6) {
                ForEach(0..<mediaFiles.count, id: \.self) { index in
                    let isSelected = currentPage == index
                    
                    Circle()
                        .fill(Color.white.opacity(isSelected ? 0.8 : 0.4))
                        .frame(width: isSelected ? 7 : 6, height: isSelected ? 7 : 6)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: currentPage)
                }
            }
            .padding(.bottom, 8)
            
            LinearGradient(
                colors: [
                    Color.black.opacity(0.2),
                    Color.clear,
                    Color.black.opacity(0.4)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .disabled(true)
        }
        .frame(height: imageHeight)
    }
}
