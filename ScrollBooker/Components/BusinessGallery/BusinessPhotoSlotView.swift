//
//  BusinessPhotoSlotView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import SwiftUI
import PhotosUI

struct BusinessPhotoSlotView: View {
    let slot: BusinessGallerySlot
    @Binding var pickerItem: PhotosPickerItem?
    let onImageLoaded: (Data) -> Void
    let onClear: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            PhotosPicker(selection: $pickerItem, matching: .images) {
                slotContent
                    .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: AppSize.base.rawValue))
            }
            .buttonStyle(.plain)

            if slot != .empty {
                Button(action: onClear) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                }
                .padding(.s)
            }
        }
        .onChange(of: pickerItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    onImageLoaded(data)
                }
            }
        }
    }

    @ViewBuilder
    private var slotContent: some View {
        switch slot {
        case .picked(let data):
            if let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                placeholder
            }

        case .existing(let url):
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .empty:
                    ProgressView()
                case .failure:
                    placeholder
                @unknown default:
                    EmptyView()
                }
            }

        case .empty:
            placeholder
        }
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: AppSize.base.rawValue)
            .fill(Color.surfaceSB)
            .overlay {
                Image(systemName: "plus.circle")
                    .font(.system(size: 35))
                    .foregroundColor(.dividerSB)
            }
    }
}
