//
//  BusinessMediaGalleryView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import SwiftUI

struct BusinessMediaGalleryView: View {
    let mediaFiles: [BusinessMediaFile]?
    
    var body: some View {
        VStack(spacing: 12) {
            if let mediaFiles {
                ForEach(mediaFiles, id: \.id) { media in
                    if let url = media.thumbnailURL {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                                .overlay(ProgressView())
                        }
                        .frame(maxWidth: .infinity)
                        .aspectRatio(16/9, contentMode: .fit)
                        .cornerRadius(12)
                        .clipped()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}


