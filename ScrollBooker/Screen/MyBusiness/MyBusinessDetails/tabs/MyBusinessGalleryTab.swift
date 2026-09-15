//
//  MyBusinessGalleryTab.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import SwiftUI
import PhotosUI

struct MyBusinessGalleryTab: View {
    let viewModel: MyBusinessDetailsViewModel

    @State private var pickerItems: [PhotosPickerItem?] = Array(
        repeating: nil,
        count: MyBusinessDetailsViewModel.slotCount
    )

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                BusinessGalleryView(
                    slots: viewModel.gallerySlots,
                    hasPhotos: viewModel.hasPhotos,
                    showEmptyHint: false,
                    pickerItems: $pickerItems,
                    onSelectImage: { index, data in
                        viewModel.setImage(data, at: index)
                    },
                    onClearSlot: { index in
                        viewModel.clearImage(at: index)
                        pickerItems[index] = nil
                    }
                )
                .padding(.base)
            }

            MainButton(
                title: String(localized: "save"),
                isDisabled: viewModel.isSavingGallery || !viewModel.hasPhotos || !viewModel.hasGalleryChanges,
                isLoading: viewModel.isSavingGallery,
                onClick: { Task { await viewModel.saveGallery() } }
            )
            .padding(.base)
        }
    }
}
