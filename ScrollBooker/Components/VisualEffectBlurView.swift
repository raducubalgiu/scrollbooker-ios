//
//  VisualEffectBlurView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.09.2026.
//

import SwiftUI

/// UIKit's `UIVisualEffectView` wrapped for SwiftUI — reach for this over `.background(.material)`
/// when the content behind the blur is a video (`AVPlayerLayer`) rather than other SwiftUI views.
/// SwiftUI's Material blur samples the standard Core Animation compositing tree and doesn't
/// reliably pick up hardware-composited video layers, so it can render as a flat haze instead of
/// an actual blur of what's playing. UIVisualEffectView doesn't have that limitation.
struct VisualEffectBlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemUltraThinMaterialDark

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
