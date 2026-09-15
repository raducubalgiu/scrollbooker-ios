//
//  BusinessPhotoSlotView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import SwiftUI
import PhotosUI

struct BusinessPhotoSlotView: View {
    let imageData: Data?
    @Binding var pickerItem: PhotosPickerItem?
    let onImageLoaded: (Data) -> Void
    let onClear: () -> Void

    private var uiImage: UIImage? {
        imageData.flatMap { UIImage(data: $0) }
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            PhotosPicker(selection: $pickerItem, matching: .images) {
                Group {
                    if let uiImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        RoundedRectangle(cornerRadius: AppSize.base.rawValue)
                            .fill(Color.surfaceSB)
                            .overlay {
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 35))
                                    .foregroundColor(.dividerSB)
                            }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
                .clipShape(RoundedRectangle(cornerRadius: AppSize.base.rawValue))
            }
            .buttonStyle(.plain)

            if uiImage != nil {
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
}
