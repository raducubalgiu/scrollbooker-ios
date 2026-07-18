//
//  PostGridView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.09.2025.
//

import SwiftUI

struct PostGridView: View {
    let postId: Int
    let mediaFiles: [PostMediaFile]
    let viewsCount: Int
    let onNavigateToPost: (Int) -> Void
    
    private let itemWidth: CGFloat = 150

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: mediaFiles.first?.thumbnailUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color(.systemGray5)
            }
            .frame(width: itemWidth, height: itemWidth * (12.0 / 9.0))
            
            LinearGradient(
                colors: [
                    Color.black.opacity(0.2),
                    Color.clear,
                    Color.black.opacity(0.45)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .disabled(true)
            
            HStack(spacing: 4) {
                Image(systemName: "play.fill")
                    .font(.system(size: 11, weight: .bold))
                
                Text("\(viewsCount)")
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.leading, 10)
            .padding(.bottom, 10)
        }
        .frame(width: itemWidth)
        .aspectRatio(9.0 / 12.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 12)) 
        .contentShape(Rectangle())
        .onTapGesture {
            onNavigateToPost(postId)
        }
    }
}
