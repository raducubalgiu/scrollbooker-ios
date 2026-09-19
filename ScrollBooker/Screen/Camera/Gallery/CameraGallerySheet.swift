//
//  CameraGallerySheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.07.2026.
//

import SwiftUI
import Photos

struct CameraGallerySheet: View {
    var viewModel: CameraViewModel
    var onVideoSelected: (LocalVideoAsset) -> Void
    @Environment(\.dismiss) private var dismiss
    
    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                SheetHeaderView(
                    onDismiss: { dismiss() },
                    title: "Galerie video"
                )

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(viewModel.videos) { videoAsset in
                            ZStack(alignment: .bottomTrailing) {
                                Group {
                                    if let thumbnail = videoAsset.thumbnail {
                                        Image(uiImage: thumbnail)
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        Color.gray.opacity(0.2)
                                    }
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: 140)
                                .clipped()
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    onVideoSelected(videoAsset)
                                }

                                Text(formatDuration(videoAsset.asset.duration))
                                    .font(.caption2.bold())
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.black.opacity(0.6))
                                    .cornerRadius(4)
                                    .padding(6)
                            }
                            .onAppear {
                                viewModel.loadMoreVideosIfNeeded(currentVideo: videoAsset)
                            }
                        }
                    }
                }
            }
            .background(Color.backgroundSB)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 25,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 25
                )
            )
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

