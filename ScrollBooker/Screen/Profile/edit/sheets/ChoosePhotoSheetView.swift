//
//  ChoosePhotoSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import SwiftUI
import PhotosUI

struct ChoosePhotoSheetView: View {
    let onPickImage: (Data) -> Void

    @State private var pickerItem: PhotosPickerItem?
    @State private var measuredHeight: CGFloat = 0

    var body: some View {
        VStack {
            PhotosPicker(selection: $pickerItem, matching: .images) {
                HStack {
                    Image(systemName: "photo.on.rectangle")
                        .foregroundColor(.onBackgroundSB)

                    Text(String(localized: "chooseFromGallery"))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.onBackgroundSB)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, .m)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
        }
        .padding(.top, .s)
        .padding(.bottom)
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { measuredHeight = geo.size.height }
                    .onChange(of: geo.size.height) { _, new in
                        measuredHeight = new
                    }
            }
        )
        .presentationDetents([.height(max(100, measuredHeight + 16))])
        .presentationContentInteraction(.resizes)
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(25)
        .onChange(of: pickerItem) { _, newItem in
            guard let newItem else { return }

            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    onPickImage(data)
                }
            }
        }
    }
}
