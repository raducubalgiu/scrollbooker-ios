//
//  CreatePostHeaderView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import SwiftUI

struct CreatePostHeaderView: View {
    let viewModel: CameraViewModel
    var onNavigateToPreview: () -> Void
    var onNavigateToCover: () -> Void

    private let previewHeight: CGFloat = 160
    private let maxLength = 500

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack(alignment: .bottom) {
                Button(action: onNavigateToPreview) {
                    Group {
                        if let cover = viewModel.coverImage ?? viewModel.selectedVideo?.thumbnail {
                            Image(uiImage: cover)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Color.surfaceSB
                        }
                    }
                    .frame(width: previewHeight * (9/12), height: previewHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)

                Button(action: onNavigateToCover) {
                    Text(String(localized: "chooseCover"))
                        .font(.footnote.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, AppSize.s.rawValue)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(AppSize.s.rawValue)
                }
                .buttonStyle(.plain)
            }
            .frame(width: previewHeight * (9/12), height: previewHeight)
            
            VStack(alignment: .trailing, spacing: 8) {
                TextField(
                    String(localized: "createPostDescriptionPlaceholder"),
                    text: Binding(
                        get: { viewModel.description },
                        set: { viewModel.setDescription($0) }
                    ),
                    axis: .vertical
                )
                .font(.subheadline)
                .lineLimit(5...5)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.clear)
                )
                
                Spacer()
                
                Text("\(viewModel.description.count) / \(maxLength)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(height: previewHeight)
        }
    }
}
