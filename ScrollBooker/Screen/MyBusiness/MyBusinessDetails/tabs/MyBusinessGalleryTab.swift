//
//  MyBusinessGalleryTab.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import SwiftUI

// TODO: pasul 5 — galerie reală (reutilizează BusinessPhotoSlotView/BusinessGalleryView din onboarding).
struct MyBusinessGalleryTab: View {
    let viewModel: MyBusinessDetailsViewModel

    var body: some View {
        Text(String(localized: "photoGallery"))
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
