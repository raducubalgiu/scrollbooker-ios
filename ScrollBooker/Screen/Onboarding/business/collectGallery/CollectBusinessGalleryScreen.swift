//
//  CollectBusinessGalleryScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI
import PhotosUI

struct CollectBusinessGalleryScreen: View {
    @Bindable var viewModel: CollectBusinessGalleryViewModel
    let onBack: () -> Void

    @State private var pickerItems: [PhotosPickerItem?] = Array(
        repeating: nil,
        count: CollectBusinessGalleryViewModel.slotCount
    )

    var body: some View {
        FormLayout(
            headline: String(localized: "onboarding_business_gallery_title"),
            subHeadline: String(localized: "onboarding_business_gallery_description"),
            enableBack: true,
            buttonTitle: String(localized: "nextStep"),
            isDisabled: viewModel.isSaving,
            isLoading: viewModel.isSaving,
            onBack: onBack,
            onClick: { Task { await viewModel.collectBusinessGallery() } }
        ) {
            ScrollView {
                BusinessGalleryView(
                    slots: viewModel.gallerySlots,
                    hasPhotos: viewModel.hasPhotos,
                    pickerItems: $pickerItems,
                    onSelectImage: { index, data in
                        viewModel.setImage(data, at: index)
                    },
                    onClearSlot: { index in
                        viewModel.clearImage(at: index)
                        pickerItems[index] = nil
                    }
                )
                .padding(.horizontal, .base)
            }
        }
    }
}
