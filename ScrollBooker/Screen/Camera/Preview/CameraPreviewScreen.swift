//
//  CameraPreviewScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.07.2026.
//

import SwiftUI
import AVKit

struct CameraPreviewScreen: View {
    let viewModel: CameraViewModel
    var isActive: Bool
    var onBack: () -> Void
    var onNext: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()

                // Shown underneath the player so re-mounting VideoPlayer (e.g. navigating
                // CreatePost -> back to this preview) never flashes black while the video
                // layer re-attaches — the already-generated cover just stays visible until
                // the video paints its own first frame over it.
                if let poster = viewModel.coverImage ?? viewModel.selectedVideo?.thumbnail {
                    Image(uiImage: poster)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 25,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 25
                            )
                        )
                }

                if let player = viewModel.player {
                    VideoPlayer(player: player)
                        .disabled(true)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipShape(
                                UnevenRoundedRectangle(
                                    topLeadingRadius: 25,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: 25
                                )
                            )
                        .transition(.opacity.animation(.easeInOut))
                } else if viewModel.isPlayerLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(1.2)
                } else {
                    Text("Nu s-a putut încărca videoclipul")
                        .foregroundColor(.white)
                        .font(.subheadline)
                }

                VStack {
                    HStack {
                        Button(action: {
                            viewModel.pauseActivePlayer()
                            onBack()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.4))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            MainButton(
                title: String(localized: "next"),
                onClick: {
                    viewModel.pauseActivePlayer()
                    onNext()
                }
            )
            .padding(.horizontal)
            .padding(.top, .m)
        }
        .task {
            viewModel.resumeOrCreatePreview()
            await viewModel.loadPostComposerData()
            await viewModel.generateCoverIfNeeded()
        }
        // This screen stays mounted (opacity-hidden, not torn down) once you navigate
        // forward from it — .task only fires once, so resuming/pausing playback on every
        // re-entry has to be driven by isActive rather than appear/disappear lifecycle.
        .onChange(of: isActive) { _, active in
            if active {
                viewModel.resumeOrCreatePreview()
            } else {
                viewModel.pauseActivePlayer()
            }
        }
        .onDisappear {
            viewModel.pauseActivePlayer()
        }
    }
}



