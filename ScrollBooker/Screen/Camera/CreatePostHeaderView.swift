//
//  CreatePostHeaderView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import SwiftUI

struct CreatePostHeaderView: View {
    let viewModel: CameraViewModel
    var onNavigateToPostPreview: () -> Void
    
    private let previewHeight: CGFloat = 160
    private let maxLength = 500 // Setează aceeași valoare ca în MAX_LENGTH din Android
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            // --- BOX PREVIEW THUMBNAIL (Stânga) ---
            Button(action: onNavigateToPostPreview) {
                ZStack(alignment: .bottom) {
                    // Afișăm thumbnail-ul gata calculat din memorie (O(1) performanță)
                    if let thumbnail = viewModel.selectedVideo?.thumbnail {
                        Image(uiImage: thumbnail)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: previewHeight * (9/12), height: previewHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        Color.surfaceSB // Înlocuiește cu culoarea ta de SurfaceBG
                            .frame(width: previewHeight * (9/12), height: previewHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    // Gradient întunecat vertical (Replică Brush.verticalGradient din Compose)
                    LinearGradient(
                        colors: [Color.black.opacity(0.2), Color.clear, Color.black.opacity(0.4)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Eticheta "Preview" fixată jos în centru
                    Text("Preview")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .padding(6)
                }
            }
            .buttonStyle(.plain)
            .frame(width: previewHeight * (9/12), height: previewHeight)
            
            // --- COLUMN TEXTFIELD & CONTOR (Dreapta) ---
            VStack(alignment: .trailing, spacing: 8) {
                TextField(
                    "Adaugă o descriere...",
                    text: Binding(
                        get: { viewModel.description },
                        set: { viewModel.setDescription($0) }
                    ),
                    axis: .vertical
                )
                .font(.body)
                // Sfat Enterprise pentru iOS 17+: lineLimit fixat cu interval controlează înălțimea geometrică a casetei,
                // exact ca minLines și maxLines din Jetpack Compose.
                .lineLimit(5...5)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.clear) // Poți pune o culoare de fundal discretă dacă vrei să arate ca în Android
                )
                
                Spacer()
                
                // Contorul de caractere aliniat la finalul coloanei
                Text("\(viewModel.description.count) / \(maxLength)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(height: previewHeight)
        }
        .padding(.horizontal, 16)
    }
}
