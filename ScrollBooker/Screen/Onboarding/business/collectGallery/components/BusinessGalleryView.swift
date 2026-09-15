//
//  BusinessGalleryView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import SwiftUI
import PhotosUI

struct BusinessGalleryView: View {
    let selectedImages: [Data?]
    let hasPhotos: Bool
    @Binding var pickerItems: [PhotosPickerItem?]
    let onSelectImage: (Int, Data) -> Void
    let onClearSlot: (Int) -> Void

    var body: some View {
        VStack(spacing: AppSize.s.rawValue) {
            if !hasPhotos {
                Text("💡 \(String(localized: "onboarding_business_gallery_skip_hint"))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.base)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.surfaceSB.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: AppSize.base.rawValue))
                    .padding(.bottom, .m)
            }

            ForEach(0..<selectedImages.count, id: \.self) { index in
                BusinessPhotoSlotView(
                    imageData: selectedImages[index],
                    pickerItem: $pickerItems[index],
                    onImageLoaded: { data in onSelectImage(index, data) },
                    onClear: { onClearSlot(index) }
                )
            }
        }
    }
}
