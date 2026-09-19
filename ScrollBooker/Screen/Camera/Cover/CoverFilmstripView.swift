//
//  CoverFilmstripView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.09.2026.
//

import SwiftUI

struct CoverFilmstripView: View {
    let frames: [CameraViewModel.CoverFrame]
    let durationSeconds: Double
    @Binding var positionSeconds: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                HStack(spacing: 0) {
                    ForEach(frames) { frame in
                        Image(uiImage: frame.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width / CGFloat(frames.count))
                            .clipped()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))

                let fraction = durationSeconds > 0 ? positionSeconds / durationSeconds : 0
                let indicatorX = min(max(fraction * geo.size.width, 2), geo.size.width - 2)

                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white)
                    .frame(width: 3, height: geo.size.height + 10)
                    .shadow(radius: 2)
                    .position(x: indicatorX, y: geo.size.height / 2)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        guard durationSeconds > 0 else { return }
                        let fraction = min(max(value.location.x / geo.size.width, 0), 1)
                        positionSeconds = fraction * durationSeconds
                    }
            )
        }
        .frame(height: 60)
    }
}
