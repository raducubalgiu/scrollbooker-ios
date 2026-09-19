//
//  CreatePostCoverScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.09.2026.
//

import SwiftUI

struct CreatePostCoverScreen: View {
    let viewModel: CameraViewModel
    var onBack: () -> Void

    @State private var positionSeconds: Double

    init(viewModel: CameraViewModel, onBack: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onBack = onBack
        _positionSeconds = State(initialValue: viewModel.coverTimeSeconds)
    }

    private var durationSeconds: Double { viewModel.videoDurationSeconds }

    // Pure in-memory lookup — no decoding happens while dragging, so this tracks the
    // finger 1:1 with no lag, matching Instagram/TikTok's scrub feel.
    private var previewFrame: UIImage? {
        viewModel.nearestFilmstripFrame(to: positionSeconds) ?? viewModel.coverImage
    }

    // The strip only ever shows a clean, fixed number of tiles regardless of how many
    // frames were actually decoded — the denser set above is for the big-preview lookup
    // only, not for what gets drawn in the scrub bar.
    private var stripDisplayFrames: [CameraViewModel.CoverFrame] {
        let all = viewModel.filmstripFrames
        let displayCount = 10
        guard all.count > displayCount else { return all }

        let step = Double(all.count - 1) / Double(displayCount - 1)
        return (0..<displayCount).map { all[Int((Double($0) * step).rounded())] }
    }

    private let headerHeight: CGFloat = 56
    private let filmstripAreaHeight: CGFloat = 76
    private let buttonAreaHeight: CGFloat = 86

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                header

                ZStack {
                    if let previewFrame {
                        Image(uiImage: previewFrame)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Color.black
                    }
                }
                .frame(
                    width: max(0, geo.size.width - AppSize.base.rawValue * 2),
                    height: previewHeight(for: geo)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .clipped()

                if !viewModel.filmstripFrames.isEmpty && durationSeconds > 0 {
                    CoverFilmstripView(
                        frames: stripDisplayFrames,
                        durationSeconds: durationSeconds,
                        positionSeconds: $positionSeconds
                    )
                    .padding(.horizontal)
                    .padding(.top, .base)
                } else {
                    ProgressView()
                        .tint(.white)
                        .frame(height: filmstripAreaHeight)
                }

                MainButton(title: String(localized: "selectCover")) {
                    viewModel.setCover(atSeconds: positionSeconds)
                    onBack()
                }
                .padding()
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            viewModel.pauseActivePlayer()
        }
        .task {
            await viewModel.ensureFilmstrip()
        }
    }

    private var header: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
            }

            Spacer()

            Text(String(localized: "chooseCover"))
                .font(.headline)
                .foregroundColor(.white)

            Spacer()

            Color.clear.frame(width: 44, height: 44)
        }
        .frame(height: headerHeight)
    }

    private func previewHeight(for geo: GeometryProxy) -> CGFloat {
        let filmstripHeight = filmstripAreaHeight
        let available = geo.size.height - headerHeight - filmstripHeight - buttonAreaHeight
        return max(0, available)
    }
}
