//
//  PlayerView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.08.2025.
//

import SwiftUI
import AVKit

struct PlayerView: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        
        // SOLUȚIA 1: Dezactivăm marginile sigure din UIKit pentru controller și vederile sale interne.
        // Acest lucru previne decalarea sau „săritura” video-ului sub Status Bar sau Tab Bar.
        controller.edgesForExtendedLayout = .all
        controller.view.clipsToBounds = true
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // SOLUȚIA 2: Când utilizatorul face scroll, SwiftUI refolosește (reciclează) controllerul.
        // Trebuie să ne asigurăm că noul player este atașat corect și își updatează frame-ul instant.
        if uiViewController.player !== player {
            uiViewController.player = player
        }
    }
}
