//
//  EditAvatarCropScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import SwiftUI

struct EditAvatarCropScreen: View {
    let viewModel: MyProfileViewModel
    var onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(onBack: onBack)

            VStack {
                Spacer()

                if let data = viewModel.pickedAvatarData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: 300)
                        .clipShape(Circle())
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            MainButton(
                title: String(localized: "save"),
                isDisabled: viewModel.isLoading,
                isLoading: viewModel.isLoading
            ) {
                guard let data = viewModel.pickedAvatarData else { return }
                Task { await viewModel.updateAvatar(photo: data) }
            }
            .padding()
        }
        .background(Color.backgroundSB)
        .onChange(of: viewModel.isSaved) { _, saved in
            if saved {
                onBack()
                viewModel.isSaved = false
            }
        }
    }
}
