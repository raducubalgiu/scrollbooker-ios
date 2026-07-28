//
//  CameraContentView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.07.2026.
//

import SwiftUI

struct CameraContentView: View {
    var showSettingsCta: Bool
    var onBack: () -> Void
    var openAppSettings: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // CustomIconButton de închidere (Close)
            Button(action: onBack) {
                Image(systemName: "xmark")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
            }
            .padding(.top, 8)
            
            Spacer()
            
            // Column cu mesajul de cameră dezactivată
            VStack(spacing: 16) {
                Image(systemName: "video.slash") // ic_video_slash_outline
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                
                Text("Camera is deactivated") // R.string.cameraIsDeactivated
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text("For the moment camera is deactivated, choose from gallery.") // R.string.forTheMomentCameraIsDeactivatedChooseFromGallery
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                if showSettingsCta {
                    Button(action: openAppSettings) {
                        Text("Open Settings") // R.string.openSettings
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 24)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(20)
                    }
                    .padding(.top, 8)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            Spacer() // Împinge conținutul ușor în sus, exact ca padding-ul top 100.dp din Android
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
